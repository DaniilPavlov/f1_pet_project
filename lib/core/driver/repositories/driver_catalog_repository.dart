import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// Каталог пилотов Jolpica (current / all) с in-memory кэшем.
class DriverCatalogRepository {
  List<DriverModel>? _currentCache;
  Future<List<DriverModel>>? _currentInFlight;

  List<DriverModel>? _allCache;
  Future<List<DriverModel>>? _allInFlight;

  Future<List<DriverModel>> loadCurrent() => _currentDrivers();

  Future<List<DriverModel>> loadAll() => _allDrivers();

  /// Ищет пилота текущего сезона по имени вида `Kimi Antonelli` / `Max Verstappen`.
  Future<DriverModel?> findByDisplayName(String displayName) async {
    final needle = displayName.trim();
    if (needle.isEmpty) {
      return null;
    }
    final drivers = await _currentDrivers();
    return _match(drivers, needle);
  }

  Future<List<DriverModel>> _currentDrivers() async {
    if (_currentCache != null) {
      return _currentCache!;
    }
    if (_currentInFlight != null) {
      return _currentInFlight!;
    }

    final future = _fetchCurrentDrivers();
    _currentInFlight = future;
    try {
      return await future;
    } finally {
      if (identical(_currentInFlight, future)) {
        _currentInFlight = null;
      }
    }
  }

  Future<List<DriverModel>> _allDrivers() async {
    if (_allCache != null) {
      return _allCache!;
    }
    if (_allInFlight != null) {
      return _allInFlight!;
    }

    final future = _fetchAllDrivers();
    _allInFlight = future;
    try {
      return await future;
    } finally {
      if (identical(_allInFlight, future)) {
        _allInFlight = null;
      }
    }
  }

  Future<List<DriverModel>> _fetchCurrentDrivers() async {
    try {
      final response = await ApiLoader.get('current/drivers');
      final drivers = _parseDrivers(response.mrData);
      _currentCache = drivers;
      return drivers;
    } on Object catch (error, stackTrace) {
      logger.e('DriverCatalogRepository.current failed', error: error, stackTrace: stackTrace);
      return _currentCache ?? const [];
    }
  }

  Future<List<DriverModel>> _fetchAllDrivers() async {
    try {
      const pageSize = 100;
      final all = <DriverModel>[];
      var offset = 0;
      var total = 1;

      while (offset < total) {
        final response = await ApiLoader.get('drivers', offset: offset);
        final mrData = response.mrData;
        if (mrData is! Map) {
          break;
        }
        total = int.tryParse(mrData['total']?.toString() ?? '') ?? all.length;
        final page = _parseDrivers(mrData);
        if (page.isEmpty) {
          break;
        }
        all.addAll(page);
        offset += pageSize;
        if (offset < total) {
          await Future<void>.delayed(const Duration(milliseconds: 280));
        }
      }

      all.sort((a, b) => a.familyName.toLowerCase().compareTo(b.familyName.toLowerCase()));
      _allCache = all;
      return all;
    } on Object catch (error, stackTrace) {
      logger.e('DriverCatalogRepository.all failed', error: error, stackTrace: stackTrace);
      return _allCache ?? const [];
    }
  }

  List<DriverModel> _parseDrivers(Object? mrData) {
    if (mrData is! Map) {
      return const [];
    }
    final table = mrData['DriverTable'];
    if (table is! Map) {
      return const [];
    }
    final raw = table['Drivers'];
    if (raw is! List) {
      return const [];
    }
    return raw
        .whereType<Map>()
        .map((e) => DriverModel.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false);
  }

  DriverModel? _match(List<DriverModel> drivers, String displayName) {
    final needle = displayName.toLowerCase().trim();

    for (final driver in drivers) {
      final full = '${driver.givenName} ${driver.familyName}'.toLowerCase().trim();
      if (full == needle) {
        return driver;
      }
    }

    final parts = needle.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) {
      return null;
    }

    final familyNeedle = parts.last;
    final givenTokens = parts.length == 1 ? <String>[] : parts.sublist(0, parts.length - 1);

    for (final driver in drivers) {
      final family = driver.familyName.toLowerCase();
      if (family != familyNeedle) {
        continue;
      }
      if (givenTokens.isEmpty) {
        return driver;
      }
      final given = driver.givenName.toLowerCase();
      final matchedGiven = givenTokens.any(
        (token) => given == token || given.contains(token) || token.contains(given.split(' ').last),
      );
      if (matchedGiven) {
        return driver;
      }
    }

    return null;
  }

  void clearCache() {
    _currentCache = null;
    _currentInFlight = null;
    _allCache = null;
    _allInFlight = null;
  }
}
