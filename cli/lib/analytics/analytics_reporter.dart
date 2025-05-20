enum AnalyticsEventType { command, result, crash }

class AnalyticsEvent {
  final AnalyticsEventType type;
  final String name;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  AnalyticsEvent({
    required this.type,
    required this.name,
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class AnalyticsReporter {
  Future<void> report(AnalyticsEvent event) async {}
}
