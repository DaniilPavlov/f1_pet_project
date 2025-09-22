import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart';
import 'package:f1_pet_project/domain/sections/hall_of_fame/hall_of_fame_screen_wm.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/sections/hof_tournament_tables_section.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/presentation/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/presentation/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/presentation/widgets/error_body.dart';
import 'package:f1_pet_project/presentation/widgets/text_fields/custom_text_field.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@RoutePage()
class HallOfFameScreen extends ElementaryWidget<IHallOfFameScreenWM> {
  const HallOfFameScreen({super.key}) : super(createHallOfFameScreenWM);

  @override
  Widget build(IHallOfFameScreenWM wm) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: StateNotifierBuilder<bool>(
          listenableState: wm.allDataIsLoaded,
          builder: (_, dataIsLoaded) {
            if (wm.screenError.value == null) {
              return dataIsLoaded! ? _Body(wm: wm) : const CustomLoadingIndicator();
            }
            return ErrorBody(
              onTap: wm.loadAllData,
              title: wm.screenError.value!.title,
              subtitle: wm.screenError.value!.subtitle,
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.wm});
  final IHallOfFameScreenWM wm;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollBehavior: AntiGlowBehavior(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: StaticData.defaultHorizontalPadding,
              vertical: StaticData.defaultVerticalPadding,
            ),
            child: const Text('Зал славы', style: AppStyles.h1),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding),
            child: Row(
              spacing: 20,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: CustomTextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.deny(RegExp('^0+')),
                      ],
                      keyboardType: TextInputType.number,
                      onChanged: (_) => wm.checkFields(),

                      label: 'Сезон',
                      hintText: 'Год',
                      controller: wm.yearController,
                    ),
                  ),
                ),
                Expanded(
                  child: StateNotifierBuilder<bool>(
                    listenableState: wm.fieldsInputted,
                    builder: (_, fieldsInputted) {
                      return wm.allDataIsLoaded.value!
                          ? BlackButton(isDisabled: !fieldsInputted!, onTap: wm.loadAllData, text: 'Поиск')
                          : const CustomLoadingIndicator();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: EntityStateNotifierBuilder<List<StandingsListsModel>>(
            listenableEntityState: wm.constructorsStandings,
            builder: (_, constructors) => EntityStateNotifierBuilder<List<StandingsListsModel>>(
              listenableEntityState: wm.driversStandings,
              builder: (_, drivers) {
                final parsedConstructors = constructors?[0].constructorStandings;
                final parsedDrivers = drivers?[0].driverStandings;
                return parsedDrivers == null || parsedConstructors == null
                    ? const SizedBox()
                    : HofTournamentTablesSection(
                        driversStandings: parsedDrivers,
                        constructorsStandings: parsedConstructors,
                      );
              },
            ),
          ),
        ),
      ],
    );
  }
}
