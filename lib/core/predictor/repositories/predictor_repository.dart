import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_season.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_store.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:f1_pet_project/services/auth/auth_service.dart';
import 'package:flutter/foundation.dart';

/// Repository: облачное хранилище предсказаний (Firestore) для авторизованного uid.
///
/// In-memory кэш привязан к [_memoryUid], чтобы после смены аккаунта
/// не отдавать данные предыдущего пользователя.
class PredictorRepository {
  PredictorRepository({
    required AuthService authService,
    FirebaseFirestore? firestore,
  }) : _authService = authService,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _memoryBackend = null,
       _uidProvider = null;

  /// In-memory backend для unit-тестов (без Firestore / Firebase Auth).
  @visibleForTesting
  PredictorRepository.memory({required String? Function() uidProvider})
    : _authService = null,
      _firestore = null,
      _memoryBackend = {},
      _uidProvider = uidProvider;

  final AuthService? _authService;
  final FirebaseFirestore? _firestore;
  final Map<String, Map<String, dynamic>>? _memoryBackend;
  final String? Function()? _uidProvider;

  PredictorStore? _memory;
  String? _memoryUid;

  String? get _uid => _uidProvider?.call() ?? _authService?.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _seasonsCol(String uid) =>
      _firestore!.collection('users').doc(uid).collection('seasons');

  /// Читает все сезоны пользователя (кэш текущего uid → Firestore / test backend).
  Future<PredictorStore> load() async {
    final uid = _uid;
    final cached = _memory;
    if (cached != null && _memoryUid == uid && uid != null) {
      return cached;
    }
    if (uid == null) {
      clearMemoryCache();
      return PredictorStore.empty();
    }

    try {
      final seasons = <String, PredictorSeason>{};
      final backend = _memoryBackend;
      if (backend != null) {
        for (final entry in backend.entries) {
          seasons[entry.key] = PredictorSeason.fromJson(entry.key, entry.value);
        }
      } else {
        final snap = await _seasonsCol(uid).get();
        for (final doc in snap.docs) {
          seasons[doc.id] = PredictorSeason.fromJson(doc.id, doc.data());
        }
      }
      final store = PredictorStore(seasons: seasons);
      _memory = store;
      _memoryUid = uid;
      return store;
    } on Object catch (e) {
      await _authService?.signOutIfSessionDead(e);
      clearMemoryCache();
      rethrow;
    }
  }

  /// Сохраняет предсказание уикенда в документ сезона.
  Future<PredictorStore> saveWeekend({
    required String year,
    required PredictorWeekendPrediction weekend,
  }) async {
    final uid = _uid;
    if (uid == null) {
      throw StateError('PredictorRepository.saveWeekend requires signed-in user');
    }
    try {
      final current = await load();
      final next = current.upsertWeekend(year: year, weekend: weekend);
      await _persistSeason(year: year, season: next.season(year)!);
      _memory = next;
      _memoryUid = uid;
      return next;
    } on Object catch (e) {
      await _authService?.signOutIfSessionDead(e);
      clearMemoryCache();
      rethrow;
    }
  }

  /// Полная замена store (для скоринга пачкой).
  Future<PredictorStore> replace(PredictorStore store) async {
    final uid = _uid;
    if (uid == null) {
      throw StateError('PredictorRepository.replace requires signed-in user');
    }
    try {
      for (final entry in store.seasons.entries) {
        await _persistSeason(year: entry.key, season: entry.value);
      }
      _memory = store;
      _memoryUid = uid;
      return store;
    } on Object catch (e) {
      await _authService?.signOutIfSessionDead(e);
      clearMemoryCache();
      rethrow;
    }
  }

  /// Сбрасывает in-memory кэш (sign-out / смена uid / мёртвая сессия).
  void clearMemoryCache() {
    _memory = null;
    _memoryUid = null;
  }

  Future<void> _persistSeason({
    required String year,
    required PredictorSeason season,
  }) async {
    final payload = season.toJson();
    final backend = _memoryBackend;
    if (backend != null) {
      backend[year] = payload;
      return;
    }
    final uid = _uid;
    if (uid == null) {
      throw StateError('PredictorRepository._persistSeason requires signed-in user');
    }
    await _seasonsCol(uid).doc(year).set({
      ...payload,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
