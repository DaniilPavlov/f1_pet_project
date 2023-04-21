import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:f1_pet_project/utils/utils.dart';
import 'package:flutter/material.dart';

class CircuitScreen extends StatelessWidget {
  final CircuitModel circuitModel;
  const CircuitScreen({required this.circuitModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Информация о трассе',
        onPop: context.router.removeLast,
      ),
      body: SafeArea(
        child: CustomScrollView(
          scrollBehavior: AntiGlowBehavior(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: StaticData.defaultHorizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Text(circuitModel.circuitName, style: AppStyles.h1),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => Utils.ULaunchUrl(rawUrl: circuitModel.url),
                      child: Text(
                        'Прочитать информацию в википедии',
                        style: AppStyles.body
                            .copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Страна: ${circuitModel.Location.country}',
                      style: AppStyles.h3,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Город: ${circuitModel.Location.locality}',
                      style: AppStyles.h3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
