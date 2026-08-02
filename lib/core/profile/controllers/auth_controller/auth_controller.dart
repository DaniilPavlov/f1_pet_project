import 'package:f1_pet_project/core/profile/utils/auth_form_validators.dart';
import 'package:f1_pet_project/services/auth/auth_service.dart';
import 'package:mobx/mobx.dart';

part 'auth_controller.g.dart';

/// Observer (MobX): состояние форм входа / регистрации.
class AuthController = AuthControllerBase with _$AuthController;

/// Поля формы + вызовы [AuthFormGateway]; ошибки как l10n-ключи.
abstract class AuthControllerBase with Store {
  AuthControllerBase({required AuthFormGateway authService}) : _authService = authService;

  final AuthFormGateway _authService;

  /// Email из поля ввода.
  @observable
  String email = '';

  /// Пароль из поля ввода.
  @observable
  String password = '';

  /// Идёт сетевой запрос auth.
  @observable
  bool isLoading = false;

  /// Ключ l10n ошибки или `null`.
  @observable
  String? errorKey;

  /// Обновляет email и сбрасывает ошибку.
  @action
  void setEmail(String value) {
    email = value;
    errorKey = null;
  }

  /// Обновляет пароль и сбрасывает ошибку.
  @action
  void setPassword(String value) {
    password = value;
    errorKey = null;
  }

  /// Вход; `true` при успехе.
  @action
  Future<bool> signIn() async {
    if (!_validateSignIn()) {
      return false;
    }
    isLoading = true;
    errorKey = null;
    try {
      final result = await _authService.signIn(email: email, password: password);
      if (!result.isSuccess) {
        errorKey = result.errorMessage;
        return false;
      }
      return true;
    } finally {
      isLoading = false;
    }
  }

  /// Регистрация; `true` при успехе.
  @action
  Future<bool> register() async {
    if (!_validateRegister()) {
      return false;
    }
    isLoading = true;
    errorKey = null;
    try {
      final result = await _authService.register(email: email, password: password);
      if (!result.isSuccess) {
        errorKey = result.errorMessage;
        return false;
      }
      return true;
    } finally {
      isLoading = false;
    }
  }

  /// Письмо сброса пароля на [email] (пароль не нужен).
  @action
  Future<bool> sendPasswordReset() async {
    if (email.trim().isEmpty) {
      errorKey = 'authErrorEmptyEmail';
      return false;
    }
    if (!AuthFormValidators.isEmailFormatOk(email)) {
      errorKey = 'authErrorInvalidEmail';
      return false;
    }
    isLoading = true;
    errorKey = null;
    try {
      final result = await _authService.sendPasswordResetEmail(email: email);
      if (!result.isSuccess) {
        errorKey = result.errorMessage;
        return false;
      }
      return true;
    } finally {
      isLoading = false;
    }
  }

  bool _validateSignIn() {
    if (email.trim().isEmpty || password.isEmpty) {
      errorKey = 'authErrorEmptyFields';
      return false;
    }
    if (!AuthFormValidators.isEmailFormatOk(email)) {
      errorKey = 'authErrorInvalidEmail';
      return false;
    }
    return true;
  }

  bool _validateRegister() {
    if (email.trim().isEmpty || password.isEmpty) {
      errorKey = 'authErrorEmptyFields';
      return false;
    }
    if (!AuthFormValidators.isEmailFormatOk(email)) {
      errorKey = 'authErrorInvalidEmail';
      return false;
    }
    if (AuthFormValidators.isDisposableEmail(email)) {
      errorKey = 'authErrorDisposableEmail';
      return false;
    }
    if (!AuthFormValidators.isPasswordStrongEnough(password)) {
      errorKey = 'authErrorWeakPassword';
      return false;
    }
    return true;
  }
}
