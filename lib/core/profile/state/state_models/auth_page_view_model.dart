import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_page_view_model.freezed.dart';

/// UI-состояние форм входа / регистрации.
@freezed
abstract class AuthPageViewModel with _$AuthPageViewModel {
  const factory AuthPageViewModel({
    /// Email пользователя.
    @Default('') String email,
    /// Пароль.
    @Default('') String password,
    /// Идёт аутентификация.
    @Default(false) bool isLoading,
    /// Ключ ошибки (локализация).
    String? errorKey,
  }) = _AuthPageViewModel;
}
