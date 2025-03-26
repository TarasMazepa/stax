import 'package:stax/settings/key_value_store.dart';
import 'package:stax/settings/setting.dart';

class DateTimeSetting extends Setting<DateTime> {
  DateTimeSetting(
    String name,
    DateTime defaultValue,
    KeyValueStore keyValueStore,
    String description,
  ) : super(
        name,
        defaultValue,
        keyValueStore,
        DateTime.parse,
        (x) => x.toIso8601String(),
        description,
      );
}
