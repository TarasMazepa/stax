import 'package:stax/settings/key_value_store.dart';
import 'package:stax/settings/setting.dart';

class StringSetting extends Setting<String> {
  StringSetting(
    String name,
    String defaultValue,
    KeyValueStore keyValueStore,
    String description,
  ) : super(name, defaultValue, keyValueStore, (s) => s, (s) => s, description);
}
