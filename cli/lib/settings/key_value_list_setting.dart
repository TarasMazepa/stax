import 'package:stax/settings/base_list_setting.dart';
import 'package:stax/settings/settings.dart';

class KeyValueListSetting extends BaseListSetting<MapEntry<String, String>> {
  KeyValueListSetting(
    String name,
    List<MapEntry<String, String>> defaultValue,
    Settings settings,
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

  void addKeyValue(String key, String value) {
    add(MapEntry(key, value));
  }

  void removeByKey(String key) {
    value = value.where((entry) => entry.key != key).toList();
  }

  String? getValue(String key) {
    return value
        .firstWhere(
          (entry) => entry.key == key,
          orElse: () => const MapEntry('', ''),
        )
        .value;
  }
}
