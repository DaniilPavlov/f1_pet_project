/// Web / non-IO stub: не считаем офлайном (нет надёжного API без плагина).
Future<bool> isOffline() async => false;
