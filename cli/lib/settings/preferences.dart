import 'package:cli_util/cli_util.dart';
import 'package:path/path.dart' as path;
import 'package:stax/settings/date_time_setting.dart';
import 'package:stax/settings/key_value_store.dart';

class Preferences extends KeyValueStore {
  late final DateTimeSetting lastUpdatePrompt = DateTimeSetting(
    'last_update_prompt',
    DateTime.now(),
    this,
    'Last time update was prompted',
  );

  Preferences()
    : super.fromPath(
        path.join(applicationConfigHome('stax'), '.stax_preferences'),
      );
}
