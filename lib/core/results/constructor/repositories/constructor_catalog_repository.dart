import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// Каталог конструкторов Jolpica (current / all) с in-memory кэшем.
class ConstructorCatalogRepository {
  List<ConstructorModel>? _currentCache;
  Future<List<ConstructorModel>>? _currentInFlight;

  List<ConstructorModel>? _allCache;
  Future<List<ConstructorModel>>? _allInFlight;

  Future<List<ConstructorModel>> loadCurrent() => _currentConstructors();

  Future<List<ConstructorModel>> loadAll() => _allConstructors();

  Future<List<ConstructorModel>> _currentConstructors() async {
    if (_currentCache != null) {
      return _currentCache!;
    }
    if (_currentInFlight != null) {
      return _currentInFlight!;
    }

    final future = _fetchCurrentConstructors();
    _currentInFlight = future;
    try {
      return await future;
    } finally {
      if (identical(_currentInFlight, future)) {
        _currentInFlight = null;
      }
    }
  }

  Future<List<ConstructorModel>> _allConstructors() async {
    if (_allCache != null) {
      return _allCache!;
    }
    if (_allInFlight != null) {
      return _allInFlight!;
    }

    final future = _fetchAllConstructors();
    _allInFlight = future;
    try {
      return await future;
    } finally {
      if (identical(_allInFlight, future)) {
        _allInFlight = null;
      }
    }
  }

  Future<List<ConstructorModel>> _fetchCurrentConstructors() async {
    try {
      final response = await ApiLoader.get('current/constructors');
      final constructors = _parseConstructors(response.mrData);
      _currentCache = constructors;
      return constructors;
    } on Object catch (error, stackTrace) {
      logger.e('ConstructorCatalogRepository.current failed', error: error, stackTrace: stackTrace);
      return _currentCache ?? const [];
    }
  }

  Future<List<ConstructorModel>> _fetchAllConstructors() async {
    try {
      const pageSize = 100;
      final all = <ConstructorModel>[];
      var offset = 0;
      var total = 1;

      while (offset < total) {
        final response = await ApiLoader.get('constructors', offset: offset);
        final mrData = response.mrData;
        if (mrData is! Map) {
          break;
        }
        total = int.tryParse(mrData['total']?.toString() ?? '') ?? all.length;
        final page = _parseConstructors(mrData);
        if (page.isEmpty) {
          break;
        }
        all.addAll(page);
        offset += pageSize;
        if (offset < total) {
          await Future<void>.delayed(const Duration(milliseconds: 280));
        }
      }

      all.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      _allCache = all;
      return all;
    } on Object catch (error, stackTrace) {
      logger.e('ConstructorCatalogRepository.all failed', error: error, stackTrace: stackTrace);
      return _allCache ?? const [];
    }
  }

  List<ConstructorModel> _parseConstructors(Object? mrData) {
    if (mrData is! Map) {
      return const [];
    }
    final table = mrData['ConstructorTable'];
    if (table is! Map) {
      return const [];
    }
    final raw = table['Constructors'];
    if (raw is! List) {
      return const [];
    }
    return raw
        .whereType<Map>()
        .map((e) => ConstructorModel.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false);
  }

  void clearCache() {
    _currentCache = null;
    _currentInFlight = null;
    _allCache = null;
    _allInFlight = null;
  }
}
