import 'package:stax/settings/setting.dart';
import 'package:stax/settings/settings.dart';

class StringSetting extends Setting<String> {
  StringSetting(
    String name,
    String defaultValue,
    Settings settings,
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
