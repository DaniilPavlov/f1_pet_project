import 'package:f1_pet_project/core/home/state/state_models/home_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит [HomePageViewModel] для главного экрана.
class HomePageStateHolder extends Notifier<HomePageViewModel> {
  @override
  HomePageViewModel build() => const HomePageViewModel();

  HomePageViewModel get viewModel => state;

  void setViewModel(HomePageViewModel value) => state = value;
}
