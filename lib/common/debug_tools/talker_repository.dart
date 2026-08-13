import 'package:f1_pet_project/common/debug_tools/debug_tools_helper.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Единый [Talker] для логов и Dio (только когда debug tools включены).
abstract final class TalkerRepository {
  static final Talker talker = Talker(
    settings: TalkerSettings(
      enabled: DebugToolsHelper.isEnabled,
      useConsoleLogs: false,
    ),
  );
}
