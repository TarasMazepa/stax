import 'package:stax/analytics/analytics_event_type.dart';

class AnalyticsEvent {
  final AnalyticsEventType type;
  final String name;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  AnalyticsEvent(this.type, this.name, this.data, DateTime? timestamp)
    : timestamp = timestamp ?? DateTime.now();
}
