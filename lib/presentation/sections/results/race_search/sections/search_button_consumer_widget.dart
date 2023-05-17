import 'package:f1_pet_project/presentation/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/presentation/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/providers/results/race_search/race_search_providers.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchButtonConsumerWidget extends ConsumerWidget {
  final VoidCallback onTap;
  const SearchButtonConsumerWidget({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fieldsInputted = ref.watch(raceSearchFieldsInputtedProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: StaticData.defaultHorizontalPadding,
      ),
      child: Consumer(
        builder: (_, ref, __) {
          // return ref.read(raceSearchResultsProvider(data)).isLoading
          return false
              ? const CustomLoadingIndicator()
              : BlackButton(
                  isDisabled: !fieldsInputted,
                  onTap: onTap,
                  text: 'Поиск',
                );
        },
      ),
    );
  }
}
