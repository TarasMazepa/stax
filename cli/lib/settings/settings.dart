import 'package:cli_util/cli_util.dart';
import 'package:path/path.dart' as path;
import 'package:stax/settings/base_settings.dart';
import 'package:stax/settings/date_time_setting.dart';
import 'package:stax/settings/key_value_list_setting.dart';
import 'package:stax/settings/string_list_setting.dart';
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

  late final KeyValueListSetting baseBranchReplacement = KeyValueListSetting(
    'base_branch_replacement',
    [],
    this,
    'Automatically substitute specific branch when creating pr: stable=main if '
        "your current branch is 'stable', but you want to have 'main' as base "
        'branch when creating PRs',
  );

  late final StringListSetting additionallyPull = StringListSetting(
    'additionally_pull',
    [],
    this,
    'Additional branches to pull besides default_branch',
  );

  Settings()
      : super.fromPath(
          path.join(applicationConfigHome('stax'), '.stax_config'),
        );
}
