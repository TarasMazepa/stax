import 'package:stax/analytics/analytics.dart';
import 'package:stax/analytics/fnv1a64.dart';
import 'package:stax/settings/preferences.dart';
import 'package:uuidv7/uuidv7.dart';

void report(List<String> arguments) {
  try {
    if (Preferences.instance.installId.value.isEmpty) {
      Preferences.instance.installId.value = generateUuidV7String();
    }
    Analytics.instance.analyticsV1.add(
      '${Preferences.instance.installId.value} ${fnv1a64String(arguments.join(' '))} ${DateTime.timestamp().toIso8601String()}',
    );
  } catch (_) {
    // ignore
  }
}
