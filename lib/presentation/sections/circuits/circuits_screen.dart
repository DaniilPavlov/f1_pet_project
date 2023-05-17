import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/presentation/widgets/containers/red_border_container.dart';
import 'package:f1_pet_project/presentation/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/presentation/widgets/error_body.dart';
import 'package:f1_pet_project/providers/circuits/circuits_provider.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class CircuitsScreen extends StatelessWidget {
  const CircuitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Consumer(
          builder: (_, ref, __) {
            final homeData = ref.watch(circuitsDataProvider);

            return homeData.when(
              loading: () => const CustomLoadingIndicator(),
              error: (err, stack) => ErrorBody(
                onTap: () => ref.refresh(circuitsDataProvider),
                title: err.toString(),
                subtitle: '',
              ),
              data: (data) => data == null
                  ? ErrorBody(
                      onTap: () => ref.refresh(circuitsDataProvider),
                      title: 'Произошла ошибка',
                      subtitle: '',
                    )
                  : _Body(circuits: data),
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final List<CircuitModel> circuits;
  const _Body({
    required this.circuits,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollBehavior: AntiGlowBehavior(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: StaticData.defaultHorizontalPadding,
            ),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: circuits.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: RedBorderContainer(
                  title: circuits[index].circuitName,
                  onTap: () async => context.router.navigate(
                    CircuitRoute(circuitModel: circuits[index]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
