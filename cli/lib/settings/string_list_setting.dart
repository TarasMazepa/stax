import 'package:stax/settings/base_list_setting.dart';
import 'package:stax/settings/key_value_store.dart';

class StringListSetting extends BaseListSetting<String> {
  StringListSetting(
    String name,
    List<String> defaultValue,
    KeyValueStore keyValueStore,
    String description,
  ) : super(name, defaultValue, keyValueStore, description, (s) => s, (s) => s);
}
