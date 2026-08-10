import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_race_win.dart';
import 'package:f1_pet_project/core/circuits/stats/models/circuit_stats.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'circuit_page_view_model.freezed.dart';

/// UI-состояние экрана трассы (winners критичны; photo/stats мягкие).
@freezed
abstract class CircuitPageViewModel with _$CircuitPageViewModel {
  const CircuitPageViewModel._();

  const factory CircuitPageViewModel({
    /// Историческое победители на трассе.
    @Default(Loadable.loading()) Loadable<List<CircuitRaceWin>> winners,
    /// URL фото трассы (мягкое издаётся на ошибку).
    @Default(Loadable.loading()) Loadable<String?> photoUrl,
    /// Статистика трассы (мягкое издаётся на ошибку).
    @Default(Loadable.loading()) Loadable<CircuitStats?> stats,
  }) = _CircuitPageViewModel;

  CustomException? get screenError => firstException([winners]);

  bool get isLoaded => winners.isValue && winners.value != null;

  bool get isPhotoLoading => photoUrl.isLoading;

  String? get circuitPhotoUrl => photoUrl.value;

  CircuitStats? get circuitStats => stats.value;
}
