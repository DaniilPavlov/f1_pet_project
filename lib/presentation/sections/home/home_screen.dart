// ignore_for_file: camel_case_types

import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/home/circuits/circuits_model.dart';
import 'package:f1_pet_project/domain/sections/home/home_screen_wm.dart';
import 'package:f1_pet_project/presentation/sections/home/circuit/circuit_element.dart';
import 'package:f1_pet_project/utils/constants/static.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behaviour.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class HomeScreen extends ElementaryWidget<HomeScreenWM> {
  const HomeScreen({
    super.key,
  }) : super(createHomeScreenWM);

  @override
  Widget build(HomeScreenWM wm) {
    return Scaffold(
      body: SafeArea(
        child: StateNotifierBuilder<bool>(
          listenableState: wm.allDataIsLoaded,
          builder: (_, dataIsLoaded) {
            if (dataIsLoaded != null) {
              return dataIsLoaded
                  ? _body(wm: wm)
                  : const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.red,
                      ),
                    );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _body extends StatelessWidget {
  final HomeScreenWM wm;
  const _body({
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
            listenableEntityState: wm.circuitsElements,
            builder: (_, items) {
              return items == null
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: StaticData.defaultPadding,
                      ),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) =>
                            CircuitElement(circuitModel: items[index]),
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }
}
