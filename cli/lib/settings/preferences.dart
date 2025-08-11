import 'package:cli_util/cli_util.dart';
import 'package:path/path.dart' as path;
import 'package:stax/settings/date_time_setting.dart';
import 'package:stax/settings/key_value_store.dart';
import 'package:stax/settings/string_setting.dart';

class Preferences extends KeyValueStore {
  late final DateTimeSetting lastUpdatePrompt = DateTimeSetting(
    'last_update_prompt',
    DateTime.now(),
    this,
    'Last time update was prompted',
  );
  late final StringSetting installId = StringSetting(
    'install_id',
    '',
    this,
    'Install id of stax',
  );

  static final instance = Preferences();

  Preferences()
    : super.fromPath(
        path.join(applicationConfigHome('stax'), '.stax_preferences'),
      );
}
