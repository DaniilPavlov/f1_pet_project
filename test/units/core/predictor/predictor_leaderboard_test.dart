import 'package:f1_pet_project/core/predictor/controllers/predictor_leaderboard_controller/predictor_leaderboard_controller.dart';
import 'package:f1_pet_project/core/predictor/repositories/predictor_leaderboard_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PredictorLeaderboardRepository.memory', () {
    test('join writes profile and ranked entry', () async {
      final repo = PredictorLeaderboardRepository.memory(uidProvider: () => 'uid-1');

      final result = await repo.join(nickname: 'Max_33', year: '2026', totalPoints: 12);
      expect(result.isSuccess, isTrue);

      final profile = await repo.loadProfile();
      expect(profile.nickname, 'Max_33');
      expect(profile.leaderboardOptIn, isTrue);
      expect(profile.canShowOnLeaderboard, isTrue);

      final board = await repo.loadLeaderboard('2026');
      expect(board, hasLength(1));
      expect(board.single.uid, 'uid-1');
      expect(board.single.rank, 1);
      expect(board.single.totalPoints, 12);
    });

    test('join rejects taken nickname', () async {
      String? uid = 'uid-1';
      final repo = PredictorLeaderboardRepository.memory(uidProvider: () => uid);
      await repo.join(nickname: 'taken', year: '2026', totalPoints: 1);

      uid = 'uid-2';
      final result = await repo.join(nickname: 'Taken', year: '2026', totalPoints: 5);
      expect(result.errorKey, 'predictorNicknameErrorTaken');
    });

    test('syncPoints updates only when opted in', () async {
      final repo = PredictorLeaderboardRepository.memory(uidProvider: () => 'uid-1');
      await repo.syncPoints(year: '2026', totalPoints: 99);
      expect(await repo.loadLeaderboard('2026'), isEmpty);

      await repo.join(nickname: 'racer', year: '2026', totalPoints: 1);
      await repo.syncPoints(year: '2026', totalPoints: 42);

      final board = await repo.loadLeaderboard('2026');
      expect(board.single.totalPoints, 42);
    });

    test('leave removes public entry but keeps nickname', () async {
      final repo = PredictorLeaderboardRepository.memory(uidProvider: () => 'uid-1');
      await repo.join(nickname: 'racer', year: '2026', totalPoints: 7);
      final leave = await repo.leave(year: '2026');
      expect(leave.isSuccess, isTrue);

      final profile = await repo.loadProfile();
      expect(profile.nickname, 'racer');
      expect(profile.leaderboardOptIn, isFalse);
      expect(await repo.loadLeaderboard('2026'), isEmpty);
    });

    test('ranks by points descending', () async {
      String? uid = 'uid-1';
      final repo = PredictorLeaderboardRepository.memory(uidProvider: () => uid);
      await repo.join(nickname: 'low', year: '2026', totalPoints: 3);
      uid = 'uid-2';
      await repo.join(nickname: 'high', year: '2026', totalPoints: 30);

      final board = await repo.loadLeaderboard('2026');
      expect(board.map((e) => e.nickname).toList(), ['high', 'low']);
      expect(board.map((e) => e.rank).toList(), [1, 2]);
    });
  });

  group('PredictorLeaderboardController', () {
    test('join requires opt-in checkbox', () async {
      final repo = PredictorLeaderboardRepository.memory(uidProvider: () => 'uid-1');
      final controller = PredictorLeaderboardController(
        repository: repo,
        year: '2026',
        myPoints: 5,
      );

      await controller.load();
      controller.setNicknameDraft('racer');
      final ok = await controller.join();
      expect(ok, isFalse);
      expect(controller.formErrorKey, 'predictorLeaderboardOptInRequired');
    });

    test('successful join loads ranked board with my entry', () async {
      final repo = PredictorLeaderboardRepository.memory(uidProvider: () => 'uid-1');
      final controller = PredictorLeaderboardController(
        repository: repo,
        year: '2026',
        myPoints: 11,
      );

      await controller.load();
      controller
        ..setNicknameDraft('racer')
        ..setOptInAgreed(true);
      final ok = await controller.join();
      expect(ok, isTrue);
      expect(controller.showJoinForm, isFalse);
      expect(controller.myEntry?.rank, 1);
      expect(controller.rankedEntries, hasLength(1));
    });
  });
}
