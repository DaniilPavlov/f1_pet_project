import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/results/finish_status/models/finish_status_item.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'finish_status_page_view_model.freezed.dart';

/// UI-состояние экрана статусов финиша.
@freezed
abstract class FinishStatusPageViewModel with _$FinishStatusPageViewModel {
  const FinishStatusPageViewModel._();

  const factory FinishStatusPageViewModel({
    /// Статусы финиша (loading/value/error).
    @Default(Loadable.loading()) Loadable<List<FinishStatusItem>> statuses,
  }) = _FinishStatusPageViewModel;

  CustomException? get screenError => statuses.exception;

  bool get isLoaded => statuses.isValue && statuses.value != null;
}
