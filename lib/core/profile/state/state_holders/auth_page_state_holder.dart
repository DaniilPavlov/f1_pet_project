import 'package:f1_pet_project/core/profile/state/state_models/auth_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит [AuthPageViewModel] для экранов входа / регистрации.
class AuthPageStateHolder extends Notifier<AuthPageViewModel> {
  @override
  AuthPageViewModel build() => const AuthPageViewModel();

  AuthPageViewModel get viewModel => state;

  void setViewModel(AuthPageViewModel value) => state = value;
}
