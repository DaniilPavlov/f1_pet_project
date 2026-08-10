import 'package:f1_pet_project/core/profile/state/state_holders/auth_page_state_holder.dart';
import 'package:f1_pet_project/core/profile/utils/auth_form_validators.dart';
import 'package:f1_pet_project/services/auth/auth_service.dart';
import 'package:flutter/foundation.dart';

/// Поля формы + вызовы [AuthFormGateway]; ошибки как l10n-ключи.
class AuthPageManager {
  AuthPageManager({
    required AuthPageStateHolder holder,
    AuthFormGateway? authService,
    @visibleForTesting AuthFormGateway? authServiceForTest,
  }) : _holder = holder,
       _authService = authServiceForTest ?? authService;

  final AuthPageStateHolder _holder;
  final AuthFormGateway? _authService;

  AuthFormGateway get _gateway => _authService!;

  /// Обновляет email и сбрасывает ошибку.
  void setEmail(String value) {
    _holder.setViewModel(_holder.viewModel.copyWith(email: value, errorKey: null));
  }

  /// Обновляет пароль и сбрасывает ошибку.
  void setPassword(String value) {
    _holder.setViewModel(_holder.viewModel.copyWith(password: value, errorKey: null));
  }

  /// Вход; `true` при успехе.
  Future<bool> signIn() async {
    if (!_validateSignIn()) {
      return false;
    }
    _holder.setViewModel(_holder.viewModel.copyWith(isLoading: true, errorKey: null));
    try {
      final result = await _gateway.signIn(
        email: _holder.viewModel.email,
        password: _holder.viewModel.password,
      );
      if (!result.isSuccess) {
        _holder.setViewModel(_holder.viewModel.copyWith(errorKey: result.errorMessage));
        return false;
      }
      return true;
    } finally {
      _holder.setViewModel(_holder.viewModel.copyWith(isLoading: false));
    }
  }

  /// Регистрация; `true` при успехе.
  Future<bool> register() async {
    if (!_validateRegister()) {
      return false;
    }
    _holder.setViewModel(_holder.viewModel.copyWith(isLoading: true, errorKey: null));
    try {
      final result = await _gateway.register(
        email: _holder.viewModel.email,
        password: _holder.viewModel.password,
      );
      if (!result.isSuccess) {
        _holder.setViewModel(_holder.viewModel.copyWith(errorKey: result.errorMessage));
        return false;
      }
      return true;
    } finally {
      _holder.setViewModel(_holder.viewModel.copyWith(isLoading: false));
    }
  }

  /// Письмо сброса пароля на email (пароль не нужен).
  Future<bool> sendPasswordReset() async {
    if (_holder.viewModel.email.trim().isEmpty) {
      _holder.setViewModel(_holder.viewModel.copyWith(errorKey: 'authErrorEmptyEmail'));
      return false;
    }
    if (!AuthFormValidators.isEmailFormatOk(_holder.viewModel.email)) {
      _holder.setViewModel(_holder.viewModel.copyWith(errorKey: 'authErrorInvalidEmail'));
      return false;
    }
    _holder.setViewModel(_holder.viewModel.copyWith(isLoading: true, errorKey: null));
    try {
      final result = await _gateway.sendPasswordResetEmail(email: _holder.viewModel.email);
      if (!result.isSuccess) {
        _holder.setViewModel(_holder.viewModel.copyWith(errorKey: result.errorMessage));
        return false;
      }
      return true;
    } finally {
      _holder.setViewModel(_holder.viewModel.copyWith(isLoading: false));
    }
  }

  bool _validateSignIn() {
    final vm = _holder.viewModel;
    if (vm.email.trim().isEmpty || vm.password.isEmpty) {
      _holder.setViewModel(vm.copyWith(errorKey: 'authErrorEmptyFields'));
      return false;
    }
    if (!AuthFormValidators.isEmailFormatOk(vm.email)) {
      _holder.setViewModel(vm.copyWith(errorKey: 'authErrorInvalidEmail'));
      return false;
    }
    return true;
  }

  bool _validateRegister() {
    final vm = _holder.viewModel;
    if (vm.email.trim().isEmpty || vm.password.isEmpty) {
      _holder.setViewModel(vm.copyWith(errorKey: 'authErrorEmptyFields'));
      return false;
    }
    if (!AuthFormValidators.isEmailFormatOk(vm.email)) {
      _holder.setViewModel(vm.copyWith(errorKey: 'authErrorInvalidEmail'));
      return false;
    }
    if (AuthFormValidators.isDisposableEmail(vm.email)) {
      _holder.setViewModel(vm.copyWith(errorKey: 'authErrorDisposableEmail'));
      return false;
    }
    if (!AuthFormValidators.isPasswordStrongEnough(vm.password)) {
      _holder.setViewModel(vm.copyWith(errorKey: 'authErrorWeakPassword'));
      return false;
    }
    return true;
  }
}
