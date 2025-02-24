import 'package:stax/settings/base_settings.dart';
import 'package:stax/settings/setting.dart';

class StringSetting extends Setting<String> {
  StringSetting(
    String name,
    String defaultValue,
    BaseSettings settings,
    String description,
  ) : super(
          name,
          defaultValue,
          settings,
          (s) => s,
          (s) => s,
          description,
        );
}
