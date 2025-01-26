import 'package:cli_util/cli_util.dart';
import 'package:path/path.dart' as path;
import 'package:stax/settings/base_settings.dart';
import 'package:stax/settings/date_time_setting.dart';
import 'package:stax/settings/string_setting.dart';

class Settings extends BaseSettings {
  late final DateTimeSetting lastUpdatePrompt = DateTimeSetting(
    'last_update_prompt',
    DateTime.now(),
    this,
    'Last time update was prompted',
  );

  late final StringSetting branchPrefix = StringSetting(
    'branch_prefix',
    '',
    this,
    'Prefix to add to all new branch names (e.g., "feature/")',
  );

  late final StringSetting defaultBranch = StringSetting(
    'default_branch',
    '',
    this,
    'Override for default branch (empty means use <remote>/HEAD)',
  );

  late final StringSetting defaultRemote = StringSetting(
    'default_remote',
    '',
    this,
    'Override for default remote (empty means use first available remote)',
  );

  Settings()
      : super.fromPath(
          path.join(applicationConfigHome('stax'), '.stax_config'),
        );
}
