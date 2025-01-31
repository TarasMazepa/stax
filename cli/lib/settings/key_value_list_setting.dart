import 'package:stax/settings/base_list_setting.dart';
import 'package:stax/settings/pair.dart';
import 'package:stax/settings/settings.dart';

class KeyValueListSetting extends BaseListSetting<Pair<String, String>> {
  KeyValueListSetting(
    String name,
    List<Pair<String, String>> defaultValue,
    Settings settings,
    String description,
  ) : super(
          name,
          defaultValue,
          settings,
          description,
          Pair.parseString,
          (pair) => pair.toString(),
        );
}
