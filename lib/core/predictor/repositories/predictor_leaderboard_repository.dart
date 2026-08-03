import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_leaderboard_entry.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_leaderboard_profile.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_nickname.dart';
import 'package:f1_pet_project/services/auth/auth_service.dart';
import 'package:flutter/foundation.dart';

/// Результат join / update nickname без исключений наружу.
class PredictorLeaderboardResult {
  const PredictorLeaderboardResult.ok() : errorKey = null;
  const PredictorLeaderboardResult.fail(this.errorKey);

  final String? errorKey;

  bool get isSuccess => errorKey == null;
}

/// Repository: профиль opt-in + публичный лидерборд сезона (Spark / client-written).
///
/// Пути:
/// - `users/{uid}` — nickname / leaderboardOptIn
/// - `nicknames/{normalized}` — uniqueness
/// - `leaderboards/{year}/entries/{uid}` — публичные очки (пишет клиент)
class PredictorLeaderboardRepository {
  PredictorLeaderboardRepository({
    required AuthService authService,
    FirebaseFirestore? firestore,
  }) : _authService = authService,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _memory = null,
       _uidProvider = null;

  @visibleForTesting
  PredictorLeaderboardRepository.memory({required String? Function() uidProvider})
    : _authService = null,
      _firestore = null,
      _memory = _MemoryBackend(),
      _uidProvider = uidProvider;

  final AuthService? _authService;
  final FirebaseFirestore? _firestore;
  final _MemoryBackend? _memory;
  final String? Function()? _uidProvider;

  String? get _uid => _uidProvider?.call() ?? _authService?.currentUser?.uid;

  /// uid текущего пользователя (для подсветки «я» в UI).
  String? get currentUid => _uid;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore!.collection('users').doc(uid);

  DocumentReference<Map<String, dynamic>> _nicknameDoc(String normalized) =>
      _firestore!.collection('nicknames').doc(normalized);

  DocumentReference<Map<String, dynamic>> _entryDoc(String year, String uid) =>
      _firestore!.collection('leaderboards').doc(year).collection('entries').doc(uid);

  /// Читает nickname / opt-in текущего пользователя.
  Future<PredictorLeaderboardProfile> loadProfile() async {
    final uid = _uid;
    if (uid == null) {
      return const PredictorLeaderboardProfile();
    }
    try {
      final memory = _memory;
      if (memory != null) {
        return memory.profiles[uid] ?? const PredictorLeaderboardProfile();
      }
      final snap = await _userDoc(uid).get();
      return PredictorLeaderboardProfile.fromJson(snap.data());
    } on Object catch (e) {
      await _authService?.signOutIfSessionDead(e);
      rethrow;
    }
  }

  /// Ранжированный список за [year] (по убыванию очков).
  Future<List<PredictorLeaderboardEntry>> loadLeaderboard(String year) async {
    try {
      final memory = _memory;
      if (memory != null) {
        final list = (memory.entries[year]?.values.toList() ?? [])
          ..sort((a, b) {
            final byPoints = b.totalPoints.compareTo(a.totalPoints);
            if (byPoints != 0) {
              return byPoints;
            }
            return a.nickname.toLowerCase().compareTo(b.nickname.toLowerCase());
          });
        return [
          for (var i = 0; i < list.length; i++) list[i].withRank(i + 1),
        ];
      }

      final snap = await _firestore!
          .collection('leaderboards')
          .doc(year)
          .collection('entries')
          .orderBy('totalPoints', descending: true)
          .get();

      final list = [
        for (final doc in snap.docs) PredictorLeaderboardEntry.fromJson(doc.id, doc.data()),
      ]..sort((a, b) {
        final byPoints = b.totalPoints.compareTo(a.totalPoints);
        if (byPoints != 0) {
          return byPoints;
        }
        return a.nickname.toLowerCase().compareTo(b.nickname.toLowerCase());
      });

      return [
        for (var i = 0; i < list.length; i++) list[i].withRank(i + 1),
      ];
    } on Object catch (e) {
      await _authService?.signOutIfSessionDead(e);
      rethrow;
    }
  }

  /// Включает участие: ник + opt-in + запись в лидерборд (в т.ч. с 0 очками).
  Future<PredictorLeaderboardResult> join({
    required String nickname,
    required String year,
    required int totalPoints,
  }) async {
    final error = PredictorNickname.validate(nickname);
    if (error != null) {
      return PredictorLeaderboardResult.fail(error);
    }
    final uid = _uid;
    if (uid == null) {
      return const PredictorLeaderboardResult.fail('predictorLeaderboardErrorGeneric');
    }

    final trimmed = nickname.trim();
    final normalized = PredictorNickname.normalize(trimmed);

    try {
      final memory = _memory;
      if (memory != null) {
        return _joinMemory(
          memory: memory,
          uid: uid,
          trimmed: trimmed,
          normalized: normalized,
          year: year,
          totalPoints: totalPoints,
        );
      }

      final userRef = _userDoc(uid);
      final nickRef = _nicknameDoc(normalized);
      final entryRef = _entryDoc(year, uid);

      return await _firestore!.runTransaction((tx) async {
        final userSnap = await tx.get(userRef);
        final profile = PredictorLeaderboardProfile.fromJson(userSnap.data());
        final previousNormalized = profile.nickname == null
            ? null
            : PredictorNickname.normalize(profile.nickname!);

        final nickSnap = await tx.get(nickRef);
        if (nickSnap.exists) {
          final owner = nickSnap.data()?['uid'];
          if (owner != uid) {
            return const PredictorLeaderboardResult.fail('predictorNicknameErrorTaken');
          }
        }

        if (previousNormalized != null && previousNormalized != normalized) {
          tx.delete(_nicknameDoc(previousNormalized));
        }

        tx
          ..set(nickRef, {
            'uid': uid,
            'nickname': trimmed,
          })
          ..set(userRef, {
            'nickname': trimmed,
            'nicknameNormalized': normalized,
            'leaderboardOptIn': true,
            'leaderboardOptInAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true))
          ..set(entryRef, {
            'nickname': trimmed,
            'totalPoints': totalPoints,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        return const PredictorLeaderboardResult.ok();
      });
    } on Object catch (e) {
      await _authService?.signOutIfSessionDead(e);
      return const PredictorLeaderboardResult.fail('predictorLeaderboardErrorGeneric');
    }
  }

  /// Выключает opt-in и удаляет публичную запись сезона.
  Future<PredictorLeaderboardResult> leave({required String year}) async {
    final uid = _uid;
    if (uid == null) {
      return const PredictorLeaderboardResult.fail('predictorLeaderboardErrorGeneric');
    }
    try {
      final memory = _memory;
      if (memory != null) {
        final profile = memory.profiles[uid] ?? const PredictorLeaderboardProfile();
        memory.profiles[uid] = profile.copyWith(leaderboardOptIn: false);
        memory.entries[year]?.remove(uid);
        return const PredictorLeaderboardResult.ok();
      }

      final batch = _firestore!.batch()
        ..set(_userDoc(uid), {
          'leaderboardOptIn': false,
        }, SetOptions(merge: true))
        ..delete(_entryDoc(year, uid));
      await batch.commit();
      return const PredictorLeaderboardResult.ok();
    } on Object catch (e) {
      await _authService?.signOutIfSessionDead(e);
      return const PredictorLeaderboardResult.fail('predictorLeaderboardErrorGeneric');
    }
  }

  /// Обновляет ник (и публичную запись, если opted-in).
  Future<PredictorLeaderboardResult> updateNickname({
    required String nickname,
    required String year,
  }) async {
    final error = PredictorNickname.validate(nickname);
    if (error != null) {
      return PredictorLeaderboardResult.fail(error);
    }
    final uid = _uid;
    if (uid == null) {
      return const PredictorLeaderboardResult.fail('predictorLeaderboardErrorGeneric');
    }

    final trimmed = nickname.trim();
    final normalized = PredictorNickname.normalize(trimmed);

    try {
      final memory = _memory;
      if (memory != null) {
        final profile = memory.profiles[uid] ?? const PredictorLeaderboardProfile();
        final previous = profile.nickname == null
            ? null
            : PredictorNickname.normalize(profile.nickname!);
        final owner = memory.nicknames[normalized];
        if (owner != null && owner != uid) {
          return const PredictorLeaderboardResult.fail('predictorNicknameErrorTaken');
        }
        if (previous != null && previous != normalized) {
          memory.nicknames.remove(previous);
        }
        memory.nicknames[normalized] = uid;
        memory.profiles[uid] = profile.copyWith(nickname: trimmed);
        final entry = memory.entries[year]?[uid];
        if (entry != null && profile.leaderboardOptIn) {
          memory.entries.putIfAbsent(year, () => {})[uid] = PredictorLeaderboardEntry(
            uid: uid,
            nickname: trimmed,
            totalPoints: entry.totalPoints,
          );
        }
        return const PredictorLeaderboardResult.ok();
      }

      final userRef = _userDoc(uid);
      final nickRef = _nicknameDoc(normalized);
      final entryRef = _entryDoc(year, uid);

      return await _firestore!.runTransaction((tx) async {
        final userSnap = await tx.get(userRef);
        final profile = PredictorLeaderboardProfile.fromJson(userSnap.data());
        final previousNormalized = profile.nickname == null
            ? null
            : PredictorNickname.normalize(profile.nickname!);

        final nickSnap = await tx.get(nickRef);
        if (nickSnap.exists) {
          final owner = nickSnap.data()?['uid'];
          if (owner != uid) {
            return const PredictorLeaderboardResult.fail('predictorNicknameErrorTaken');
          }
        }

        // Все reads до любых writes (требование Firestore transaction).
        final entrySnap = profile.leaderboardOptIn ? await tx.get(entryRef) : null;

        if (previousNormalized != null && previousNormalized != normalized) {
          tx.delete(_nicknameDoc(previousNormalized));
        }

        tx
          ..set(nickRef, {
            'uid': uid,
            'nickname': trimmed,
          })
          ..set(userRef, {
            'nickname': trimmed,
            'nicknameNormalized': normalized,
          }, SetOptions(merge: true));

        if (entrySnap != null && entrySnap.exists) {
          final points = entrySnap.data()?['totalPoints'];
          tx.set(entryRef, {
            'nickname': trimmed,
            'totalPoints': points is int ? points : (points is num ? points.toInt() : 0),
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
        return const PredictorLeaderboardResult.ok();
      });
    } on Object catch (e) {
      await _authService?.signOutIfSessionDead(e);
      return const PredictorLeaderboardResult.fail('predictorLeaderboardErrorGeneric');
    }
  }

  /// Синхронизирует очки в публичную запись, если пользователь opted-in.
  /// Ошибки глотаются (личный прогресс важнее публичного зеркала).
  Future<void> syncPoints({
    required String year,
    required int totalPoints,
  }) async {
    final uid = _uid;
    if (uid == null) {
      return;
    }
    try {
      final memory = _memory;
      if (memory != null) {
        final profile = memory.profiles[uid];
        if (profile == null || !profile.canShowOnLeaderboard) {
          return;
        }
        memory.entries.putIfAbsent(year, () => {})[uid] = PredictorLeaderboardEntry(
          uid: uid,
          nickname: profile.nickname!,
          totalPoints: totalPoints,
        );
        return;
      }

      final profile = await loadProfile();
      if (!profile.canShowOnLeaderboard) {
        return;
      }
      await _entryDoc(year, uid).set({
        'nickname': profile.nickname,
        'totalPoints': totalPoints,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } on Object catch (e) {
      await _authService?.signOutIfSessionDead(e);
    }
  }

  void clearMemoryCache() {}

  PredictorLeaderboardResult _joinMemory({
    required _MemoryBackend memory,
    required String uid,
    required String trimmed,
    required String normalized,
    required String year,
    required int totalPoints,
  }) {
    final owner = memory.nicknames[normalized];
    if (owner != null && owner != uid) {
      return const PredictorLeaderboardResult.fail('predictorNicknameErrorTaken');
    }
    final previous = memory.profiles[uid]?.nickname;
    if (previous != null) {
      final prevNorm = PredictorNickname.normalize(previous);
      if (prevNorm != normalized) {
        memory.nicknames.remove(prevNorm);
      }
    }
    memory.nicknames[normalized] = uid;
    memory.profiles[uid] = PredictorLeaderboardProfile(
      nickname: trimmed,
      leaderboardOptIn: true,
    );
    memory.entries.putIfAbsent(year, () => {})[uid] = PredictorLeaderboardEntry(
      uid: uid,
      nickname: trimmed,
      totalPoints: totalPoints,
    );
    return const PredictorLeaderboardResult.ok();
  }
}

class _MemoryBackend {
  final Map<String, PredictorLeaderboardProfile> profiles = {};
  final Map<String, String> nicknames = {};
  final Map<String, Map<String, PredictorLeaderboardEntry>> entries = {};
}
