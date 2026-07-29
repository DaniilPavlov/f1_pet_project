import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';

/// Captures analytics events for assertions in widget/unit tests.
class RecordingAnalyticsGateway implements AnalyticsGateway {
  final events = <AnalyticsEvent>[];

  @override
  void log(AnalyticsEvent event) => events.add(event);
}
