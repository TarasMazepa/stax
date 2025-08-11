import 'package:cli_util/cli_util.dart';
import 'package:stax/settings/key_value_store.dart';
import 'package:path/path.dart' as path;
import 'package:stax/settings/string_list_setting.dart';

class Analytics extends KeyValueStore {
  late final StringListSetting analyticsV1 = StringListSetting(
    'v1',
    [],
    this,
    'Analytics v1',
  );

  static final Analytics instance = Analytics();

  Analytics()
    : super.fromPath(
        path.join(applicationConfigHome('stax'), '.stax_analytics'),
      );
}
