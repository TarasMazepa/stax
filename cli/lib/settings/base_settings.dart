import 'package:stax/branch_name/parametrized_branch_sanitization.dart';
import 'package:stax/settings/key_value_list_setting.dart';
import 'package:stax/settings/key_value_store.dart';
import 'package:stax/settings/string_list_setting.dart';
import 'package:stax/settings/string_setting.dart';

mixin BaseSettings implements KeyValueStore {
  late final additionallyPull = StringListSetting(
    'additionally_pull',
    [],
    this,
    'Additional branches to pull besides default_branch',
  );
  late final baseBranchReplacement = KeyValueListSetting(
    'base_branch_replacement',
    [],
    this,
    'Automatically substitute specific branch when creating pr: stable=main if '
        "your current branch is 'stable', but you want to have 'main' as base "
        'branch when creating PRs',
  );
  late final branchPrefix = StringSetting(
    'branch_prefix',
    '',
    this,
    'Prefix to add to all new branch names (e.g., "username/")',
  );
  late final branchNameSymbolSanitizationRegEx = StringSetting(
    'branch_name_symbol_sanitization_reg_ex',
    defaultAcceptedRegEx,
    this,
    'An ECMAScript compatible regular expression that is being evaluated with u'
        ' (for unicode) flag. This allows a control over what characters are '
        'being allowed in commit message to branch name transformation, when '
        '`stax commit` is used without explicit branch name. `stax commit` will'
        ' offer branch name that is based on commit message. It will use this '
        'regular expression as well as `git check-ref-format` rules. By default'
        ' stax would use following regular expression: $defaultAcceptedRegEx. '
        'It is very easy to shoot yourself in the foot by setting this setting,'
        ' so be careful. To reset use `stax settings clear '
        'branch_name_symbol_sanitization_reg_ex`. The simplest filter to set is'
        ' `.`, which will effectively fallback to `git check-ref-format`.',
  );
  late final defaultBranch = StringSetting(
    'default_branch',
    '',
    this,
    'Override for default branch (empty means use <remote>/HEAD)',
  );
  late final defaultRemote = StringSetting(
    'default_remote',
    '',
    this,
    'Override for default remote (empty means use first available remote)',
  );
}
