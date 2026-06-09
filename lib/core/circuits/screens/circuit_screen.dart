import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/utils.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CircuitScreen extends StatelessWidget {
  const CircuitScreen({required this.circuitModel, super.key});
  final CircuitModel circuitModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Информация о трассе', onPop: context.router.removeLast),
      body: SafeArea(
        child: CustomScrollView(
          scrollBehavior: AntiGlowBehavior(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Text(circuitModel.circuitName, style: AppStyles.h1),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => Utils.openUrl(rawUrl: circuitModel.url),
                      child: Text(
                        'Прочитать информацию в википедии',
                        style: AppStyles.body.copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Страна: ${circuitModel.location.country}', style: AppStyles.h3),
                    const SizedBox(height: 10),
                    Text('Город: ${circuitModel.location.locality}', style: AppStyles.h3),
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
