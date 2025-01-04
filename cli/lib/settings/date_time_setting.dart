import 'package:stax/settings/setting.dart';
import 'package:stax/settings/settings.dart';

class DateTimeSetting extends Setting<DateTime> {
  DateTimeSetting(
    String name,
    DateTime defaultValue,
    Settings settings,
    String description,
  ) : super(
          name,
          defaultValue,
          settings,
          DateTime.parse,
          (x) => x.toIso8601String(),
          description,
        );
}
