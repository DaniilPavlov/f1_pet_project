import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/presentation/sections/home/sections/tournament_tables/tournament_tables_section.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/presentation/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/presentation/widgets/error_body.dart';
import 'package:f1_pet_project/providers/home/home_data.dart';
import 'package:f1_pet_project/providers/home/home_providers.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Consumer(
          builder: (_, ref, __) {
            final homeData = ref.watch(homeDataProvider);

            return homeData.when(
              loading: () => const CustomLoadingIndicator(),
              error: (err, stack) => ErrorBody(
                onTap: () => ref.refresh(homeDataProvider),
                title: err.toString(),
                subtitle: '',
              ),
              data: (data) => data.constructors == null ||
                      data.drivers == null ||
                      data.round == null ||
                      data.season == null
                  ? ErrorBody(
                      onTap: () => ref.refresh(homeDataProvider),
                      title: 'Произошла ошибка',
                      subtitle: '',
                    )
                  : _Body(homeData: data),
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final HomeData homeData;
  const _Body({required this.homeData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollBehavior: AntiGlowBehavior(),
      slivers: [
        SliverToBoxAdapter(
          child: TournamentTablesSection(
            driversStandings: homeData.drivers!,
            constructorsStandings: homeData.constructors!,
            season: homeData.season!,
            round: homeData.round!,
          ),
        ),
      ],
    );
  }
}
