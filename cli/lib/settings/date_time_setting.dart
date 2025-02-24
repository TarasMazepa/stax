import 'package:stax/settings/base_settings.dart';
import 'package:stax/settings/setting.dart';

class DateTimeSetting extends Setting<DateTime> {
  DateTimeSetting(
    String name,
    DateTime defaultValue,
    BaseSettings settings,
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
