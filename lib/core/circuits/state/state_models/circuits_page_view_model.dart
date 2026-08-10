import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'circuits_page_view_model.freezed.dart';

/// UI-состояние экрана списка трасс.
@freezed
sealed class CircuitsPageViewModel with _$CircuitsPageViewModel {
  const CircuitsPageViewModel._();

  const factory CircuitsPageViewModel.loading({@Default(0) int activePage}) = CircuitsPageLoading;

  const factory CircuitsPageViewModel.error({
    required CustomException exception,
    @Default(0) int activePage,
  }) = CircuitsPageError;

  const factory CircuitsPageViewModel.success({
    required List<CircuitModel> circuits,
    @Default(0) int activePage,
    @Default(false) bool showingCachedData,
  }) = CircuitsPageSuccess;

  CustomException? get screenError => switch (this) {
        CircuitsPageError(:final exception) => exception,
        _ => null,
      };

  bool get isLoading => this is CircuitsPageLoading;

  bool get isError => this is CircuitsPageError;

  bool get isSuccess => this is CircuitsPageSuccess;
}
