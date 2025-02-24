import 'package:collection/collection.dart';
import 'package:stax/settings/base_list_setting.dart';
import 'package:stax/settings/base_settings.dart';

class KeyValueListSetting extends BaseListSetting<MapEntry<String, String>> {
  KeyValueListSetting(
    String name,
    List<MapEntry<String, String>> defaultValue,
    BaseSettings settings,
    String description,
  ) : super(
          name,
          defaultValue,
          settings,
          description,
          (s) => switch (s.split('=')) {
            [final key, final value] => MapEntry(key, value),
            _ => throw FormatException('Invalid key-value format: $s'),
          },
          (entry) => '${entry.key}=${entry.value}',
        );

  void addRaw(String value) {
    final parsed = itemFromString(value)!;
    removeByKey(parsed.key);
    add(parsed);
  }

  void removeByKey(String key) {
    value = value.where((entry) => entry.key != key).toList();
  }

  String? getValue(String key) {
    return value
        .firstWhereOrNull(
          (entry) => entry.key == key,
        )
        ?.value;
  }
}
