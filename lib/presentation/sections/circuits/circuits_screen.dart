import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart';
import 'package:f1_pet_project/domain/sections/circuits/circuits_screen_wm.dart';
import 'package:f1_pet_project/presentation/widgets/containers/red_border_container.dart';
import 'package:f1_pet_project/router/router.gr.dart';
import 'package:f1_pet_project/utils/constants/static.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behaviour.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class CircuitsScreen extends ElementaryWidget<ICircuitsScreenWM> {
  const CircuitsScreen({
    super.key,
  }) : super(createCircuitsScreenWM);

  @override
  Widget build(ICircuitsScreenWM wm) {
    return Scaffold(
      body: SafeArea(
        child: StateNotifierBuilder<bool>(
          listenableState: wm.allDataIsLoaded,
          builder: (_, dataIsLoaded) {
            if (dataIsLoaded != null) {
              return dataIsLoaded
                  ? _Body(wm: wm)
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
                        itemBuilder: (context, index) => RedBorderContainer(
                          title: items[index].circuitName,
                          onTap: () async => context.router.navigate(
                            CircuitRoute(circuitModel: items[index]),
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
