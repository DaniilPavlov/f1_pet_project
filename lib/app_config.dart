import 'package:envied/envied.dart';

part 'app_config.g.dart';

/// Values from local gitignored `.env`. Release may override via `--dart-define`.
@Envied(path: '.env', requireEnvFile: false)
abstract final class AppConfig {
  @EnviedField(varName: 'APPMETRICA_API_KEY', obfuscate: true, defaultValue: '')
  static final String appMetricaApiKey = _AppConfig.appMetricaApiKey;
}
