import 'package:cli_util/cli_util.dart';
import 'package:path/path.dart' as path;
import 'package:stax/settings/base_settings.dart';
import 'package:stax/settings/key_value_store.dart';

class Settings extends KeyValueStore with BaseSettings {
  Settings()
    : super.fromPath(path.join(applicationConfigHome('stax'), '.stax_config'));

  @override
  String get name => '--global';
}
