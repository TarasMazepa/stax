import 'package:stax/settings/base_list_setting.dart';
import 'package:stax/settings/settings.dart';

class StringListSetting extends BaseListSetting<String> {
  StringListSetting(
    String name,
    List<String> defaultValue,
    Settings settings,
    String description,
  ) : super(
          name,
          defaultValue,
          settings,
          description,
          (s) => s,
          (s) => s,
        );
}
