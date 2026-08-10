import 'package:f1_pet_project/core/results/constructor/managers/constructor_page_manager.dart';
import 'package:f1_pet_project/core/results/constructor/state/state_holders/constructor_page_state_holder.dart';
import 'package:f1_pet_project/core/results/constructor/state/state_models/constructor_page_args.dart';
import 'package:f1_pet_project/core/results/constructor/state/state_models/constructor_page_view_model.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State holder экрана конструктора (family по [ConstructorPageArgs]).
final constructorPageStateHolderProvider =
    NotifierProvider.autoDispose.family<ConstructorPageStateHolder, ConstructorPageViewModel, ConstructorPageArgs>(
      ConstructorPageStateHolder.new,
    );

/// Manager экрана конструктора.
final constructorPageManagerProvider =
    Provider.autoDispose.family<ConstructorPageManager, ConstructorPageArgs>((ref, args) {
      final manager = ConstructorPageManager(
        args: args,
        holder: ref.watch(constructorPageStateHolderProvider(args).notifier),
        careerRepository: ref.watch(constructorCareerRepositoryProvider),
        espnMediaRepository: ref.watch(espnMediaRepositoryProvider),
        dataRefresh: ref.watch(appDataRefreshProvider),
      );
      ref.onDispose(manager.dispose);
      return manager;
    });
