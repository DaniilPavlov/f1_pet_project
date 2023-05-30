import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart';
import 'package:f1_pet_project/domain/sections/circuits/circuits_screen_wm.dart';
import 'package:f1_pet_project/presentation/sections/circuits/widgets/circuits_list.dart';
import 'package:f1_pet_project/presentation/sections/circuits/widgets/circuits_map.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/presentation/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/presentation/widgets/custom_switcher.dart';
import 'package:f1_pet_project/presentation/widgets/error_body.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CircuitsScreen extends ElementaryWidget<ICircuitsScreenWM> {
  const CircuitsScreen({
    super.key,
  }) : super(createCircuitsScreenWM);

  @override
  Widget build(ICircuitsScreenWM wm) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: EntityStateNotifierBuilder<List<CircuitModel>>(
            listenableEntityState: wm.circuits,
            builder: (_, __) => StateNotifierBuilder<int>(
              listenableState: wm.activePage,
              builder: (_, activePage) => Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomSwitcher(
                    firstTitle: 'На карте',
                    secondTitle: 'Списком',
                    onChanged: wm.changeActivePage,
                    activeValue: activePage!,
                  ),
                  Expanded(
                    child: PageView(
                      onPageChanged: wm.changeActivePage,
                      controller: wm.pageController,
                      children: [
                        CircuitsMap(
                          circuits: wm.circuits.value!.data ?? [],
                          openCircuitInfo: wm.openCircuitInfo,
                        ),
                        CircuitsList(circuits: wm.circuits.value!.data ?? []),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            loadingBuilder: (_, __) => const CustomLoadingIndicator(),
            errorBuilder: (_, e, __) => ErrorBody(
              onTap: wm.loadAllData,
              title: wm.screenError.value!.title,
              subtitle: wm.screenError.value!.subtitle,
            ),
          ),
        ),
      ),
    );
  }
}

// class _Body extends StatelessWidget {
//   final ICircuitsScreenWM wm;
//   const _Body({
//     required this.wm,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       scrollBehavior: AntiGlowBehavior(),
//       slivers: [
//         //
//         SliverToBoxAdapter(
//           child: EntityStateNotifierBuilder<List<CircuitModel>>(
//             listenableEntityState: wm.circuits,
//             builder: (_, items) {
//               return items == null
//                   ? const SizedBox()
//                   : Padding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 20,
//                         horizontal: StaticData.defaultHorizontalPadding,
//                       ),
//                       child: ListView.builder(
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: items.length,
//                         shrinkWrap: true,
//                         itemBuilder: (context, index) => Padding(
//                           padding: const EdgeInsets.only(bottom: 20),
//                           child: RedBorderContainer(
//                             title: items[index].circuitName,
//                             onTap: () async => context.router.navigate(
//                               CircuitRoute(circuitModel: items[index]),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
