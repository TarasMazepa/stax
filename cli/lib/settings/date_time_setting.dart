import 'package:stax/settings/setting.dart';

class DateTimeSetting extends Setting<DateTime> {
  DateTimeSetting(name, defaultValue, settings)
      : super(
          name,
          defaultValue,
          settings,
          DateTime.parse,
          (x) => x.toIso8601String(),
        );
}
