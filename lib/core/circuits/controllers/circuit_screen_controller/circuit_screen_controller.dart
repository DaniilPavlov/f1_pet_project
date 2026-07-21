import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/common/wikipedia/loaders/wikipedia_page_image_loader.dart';
import 'package:f1_pet_project/core/circuits/loaders/circuit_history_loader.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_race_win.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:mobx/mobx.dart';

part 'circuit_screen_controller.g.dart';

/// MobX-контроллер экрана трассы.
class CircuitScreenController = CircuitScreenControllerBase with _$CircuitScreenController;

/// Загружает историю побед и фото трассы (Wikipedia).
abstract class CircuitScreenControllerBase with Store {
  CircuitScreenControllerBase({
    required this.circuit,
    Future<List<CircuitRaceWin>> Function({required String circuitId})? fetchWinners,
    Future<String?> Function(String articleUrl)? fetchPhotoUrl,
  }) : _fetchWinnersOverride = fetchWinners,
       _fetchPhotoUrlOverride = fetchPhotoUrl;

  final CircuitModel circuit;
  final Future<List<CircuitRaceWin>> Function({required String circuitId})? _fetchWinnersOverride;
  final Future<String?> Function(String articleUrl)? _fetchPhotoUrlOverride;

  @observable
  AsyncValue<List<CircuitRaceWin>> winners = const AsyncValue.loading();

  @observable
  AsyncValue<String?> photoUrl = const AsyncValue.loading();

  @computed
  CustomException? get screenError => firstException([winners]);

  @computed
  bool get isLoaded => winners.isValue && winners.value != null;

  @computed
  bool get isPhotoLoading => photoUrl.isLoading;

  @computed
  String? get circuitPhotoUrl => photoUrl.value;

  /// Загружает победителей и фото параллельно.
  @action
  Future<void> loadAll() async {
    await Future.wait([loadWinners(), loadPhoto()]);
  }

  /// Загружает (или перезагружает) список победителей.
  @action
  Future<void> loadWinners() async {
    await runAsyncLoad(
      fetch: () => _fetchWinners(circuitId: circuit.circuitId),
      getField: () => winners,
      setField: (value) => winners = value,
      onSuccess: (data) {
        if (data != null) {
          winners = winners.toValue(data);
        }
      },
    );
  }

  /// Фото из Wikipedia; ошибка не ломает экран.
  @action
  Future<void> loadPhoto() async {
    photoUrl = photoUrl.toLoading();
    try {
      final url = await _fetchPhoto(circuit.url);
      photoUrl = photoUrl.toValue(url);
    } on Object {
      photoUrl = const AsyncValue.value();
    }
  }

  Future<List<CircuitRaceWin>> _fetchWinners({required String circuitId}) {
    final override = _fetchWinnersOverride;
    if (override != null) {
      return override(circuitId: circuitId);
    }
    return CircuitHistoryLoader.loadWinners(circuitId: circuitId);
  }

  Future<String?> _fetchPhoto(String articleUrl) {
    final override = _fetchPhotoUrlOverride;
    if (override != null) {
      return override(articleUrl);
    }
    return WikipediaPageImageLoader.loadThumbnail(articleUrl: articleUrl);
  }
}
