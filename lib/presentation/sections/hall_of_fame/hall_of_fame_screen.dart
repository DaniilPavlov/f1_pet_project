import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/sections/champions/champions_section.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/presentation/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/presentation/widgets/error_body.dart';
import 'package:f1_pet_project/providers/hall_of_fame/hall_of_fame_data.dart';
import 'package:f1_pet_project/providers/hall_of_fame/hall_of_fame_providers.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class HallOfFameScreen extends StatelessWidget {
  const HallOfFameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Consumer(
          builder: (_, ref, __) {
            final hallOfFameData = ref.watch(hallOfFameDataProvider);
            return hallOfFameData.when(
              loading: () => const CustomLoadingIndicator(),
              error: (err, stack) => ErrorBody(
                onTap: () => ref.refresh(hallOfFameDataProvider),
                title: err.toString(),
                subtitle: '',
              ),
              data: (data) => data.constructors == null || data.drivers == null
                  ? ErrorBody(
                      onTap: () => ref.refresh(hallOfFameDataProvider),
                      title: 'Произошла ошибка',
                      subtitle: '',
                    )
                  : _Body(data: data),
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final HallOfFameData data;
  const _Body({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollBehavior: AntiGlowBehavior(),
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ChampionsSection(
                constructorsChampions: data.constructors!,
                driversChampions: data.drivers!,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
