import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Состояние плавающей debug-кнопки: позиция и видимость inspector.
final class DebugToolsController extends ChangeNotifier {
  DebugToolsController() {
    _loadPosition();
  }

  static const _prefsKeyDx = 'debug_tools_button_dx';
  static const _prefsKeyDy = 'debug_tools_button_dy';
  static const _defaultOffset = Offset(20, 100);

  Offset _buttonOffset = _defaultOffset;
  var _positionReady = false;
  var _inspectorVisible = false;

  Offset get buttonOffset => _buttonOffset;
  bool get positionReady => _positionReady;
  bool get inspectorVisible => _inspectorVisible;

  Future<void> _loadPosition() async {
    final prefs = await SharedPreferences.getInstance();
    final dx = prefs.getDouble(_prefsKeyDx);
    final dy = prefs.getDouble(_prefsKeyDy);
    if (dx != null && dy != null) {
      _buttonOffset = Offset(dx, dy);
    }
    _positionReady = true;
    notifyListeners();
  }

  Future<void> writePosition(Offset position) async {
    _buttonOffset = position;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefsKeyDx, position.dx);
    await prefs.setDouble(_prefsKeyDy, position.dy);
  }

  void toggleInspector() {
    _inspectorVisible = !_inspectorVisible;
    notifyListeners();
  }
}
