import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart';
import 'package:f1_pet_project/domain/sections/circuits/circuits_screen_wm.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/presentation/widgets/containers/red_border_container.dart';
import 'package:f1_pet_project/presentation/widgets/custom_loading_indicator.dart';

import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behavior.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CircuitsScreen extends ElementaryWidget<ICircuitsScreenWM> {
  const CircuitsScreen({
    super.key,
  }) : super(createCircuitsScreenWM);

  @override
  Widget build(ICircuitsScreenWM wm) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: StateNotifierBuilder<bool>(
          listenableState: wm.allDataIsLoaded,
          builder: (_, dataIsLoaded) {
            if (dataIsLoaded != null) {
              return dataIsLoaded
                  ? _Body(wm: wm)
                  : const CustomLoadingIndicator();
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final ICircuitsScreenWM wm;
  const _Body({
    required this.wm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollBehavior: AntiGlowBehavior(),
      slivers: [
        //
        SliverToBoxAdapter(
          child: EntityStateNotifierBuilder<List<CircuitModel>>(
            listenableEntityState: wm.circuits,
            builder: (_, items) {
              return items == null
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: StaticData.defaultHorizontalPadding,
                      ),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: RedBorderContainer(
                            title: items[index].circuitName,
                            onTap: () async =>
                                context.go('/circuits/circuit', extra: items[index]),
                          ),
                        ),
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }
}
