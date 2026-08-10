import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifications_preference_view_model.freezed.dart';

/// UI-состояние prefs локальных race reminders.
@freezed
abstract class NotificationsPreferenceViewModel with _$NotificationsPreferenceViewModel {
  const NotificationsPreferenceViewModel._();

  const factory NotificationsPreferenceViewModel({
    /// Пользователь включил напоминания.
    @Default(true) bool userEnabled,
    /// Включены напоминания о практиках.
    @Default(true) bool practiceRemindersEnabled,
    /// Настройки загружены.
    @Default(false) bool isLoaded,
  }) = _NotificationsPreferenceViewModel;

  bool get effectivelyEnabled => userEnabled;

  bool get canToggle => true;

  bool get canTogglePractice => effectivelyEnabled;

  bool get practiceRemindersEffectivelyEnabled => effectivelyEnabled && practiceRemindersEnabled;
}
