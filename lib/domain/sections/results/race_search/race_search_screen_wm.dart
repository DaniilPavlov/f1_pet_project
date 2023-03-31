import 'package:beamer/beamer.dart';
import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/schedule_model.dart';
import 'package:f1_pet_project/domain/sections/results/race_search/race_search_screen_model.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/presentation/sections/results/race_search/race_search_screen.dart';
import 'package:flutter/material.dart';

class RaceSearchScreenWM
    extends WidgetModel<RaceSearchScreen, RaceSearchScreenModel>
    implements IRaceSearchScreenWM {
  final _scrollController = ScrollController();

  final _yearController = TextEditingController();

  final _roundController = TextEditingController();

  final _searchedRace = EntityStateNotifier<RacesModel?>();

  final _dataIsLoaded = StateNotifier<bool>(initValue: true);

  final _fieldsInputted = StateNotifier<bool>(initValue: false);

  final _errorMessage = StateNotifier<String>(initValue: '');

  @override
  ListenableState<EntityState<RacesModel?>> get searchedRace => _searchedRace;

  @override
  ListenableState<bool> get dataIsLoaded => _dataIsLoaded;

  @override
  ListenableState<bool> get fieldsInputted => _fieldsInputted;

  @override
  ListenableState<String> get errorMessage => _errorMessage;

  @override
  TextEditingController get yearController => _yearController;

  @override
  TextEditingController get roundController => _roundController;

  @override
  ScrollController get scrollController => _scrollController;

  @override
  String get fastestLap => _fastestLap;

  String _fastestLap = '999999';

  RaceSearchScreenWM(super.model);

  @override
  void onPop() => Beamer.of(context).popRoute();

  @override
  void checkFields() => _fieldsInputted.accept(
        _yearController.text.length == 4 && _roundController.text.isNotEmpty,
      );

  @override
  Future<void> loadRaceResults() async {
    _dataIsLoaded.accept(false);
    FocusManager.instance.primaryFocus?.unfocus();
    await execute<ScheduleModel>(
      () => model.loadRaceResults(
        year: _yearController.text,
        round: _roundController.text,
      ),
      before: _searchedRace.loading,
      onSuccess: (data) {
        _errorMessage.accept('');
        if (data!.RaceTable.Races.isNotEmpty) {
          _searchedRace.content(data.RaceTable.Races[0]);
          Future<void>.delayed(
            const Duration(milliseconds: 100),
            _animateToTable,
          );
        } else {
          _searchedRace.content(null);
          _errorMessage.accept(
            'По вашему запросу гонок не найдено. Проверьте введенные данные и попробуйте еще раз.',
          );
        }
      },
      onError: (error) {
        _searchedRace.error(error);
        _errorMessage.accept(error.title);
      },
    );
    if (_searchedRace.value!.data != null) {
      for (final element in _searchedRace.value!.data!.Results!) {
        if (element.FastestLap != null &&
            _fastestLap.compareTo(element.FastestLap!.Time.time) == 1) {
          _fastestLap = element.FastestLap!.Time.time;
        }
      }
    }

    _dataIsLoaded.accept(true);
  }

  /// Scrolls to race table.
  void _animateToTable() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(
        milliseconds: 200,
      ),
      curve: Curves.easeOutCubic,
    );
  }
}

RaceSearchScreenWM createRaceSearchScreenWM(BuildContext _) =>
    RaceSearchScreenWM(RaceSearchScreenModel());

abstract class IRaceSearchScreenWM extends IWidgetModel {
  /// Returns screen scroll controller.
  ScrollController get scrollController;

  /// Returns year text field controller.
  TextEditingController get yearController;

  /// Returns round text field controller.
  TextEditingController get roundController;

  /// Returns searched race info.
  ListenableState<EntityState<RacesModel?>> get searchedRace;

  /// Returns error message.
  ///
  /// It can be 'races were not found', 'no internet connection' or 'server response error'.
  ListenableState<String> get errorMessage;

  /// Returns is race loaded.
  ListenableState<bool> get dataIsLoaded;

  /// Returns are fields inputted.
  ListenableState<bool> get fieldsInputted;

  /// Returns fastest lap.
  String get fastestLap;

  /// Closes screen.
  void onPop();

  /// Loads race results.
  void loadRaceResults();

  /// Checks are fields valid.
  void checkFields();
}
