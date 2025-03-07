import 'package:path/path.dart' as path;
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_repository_root.dart';
import 'package:stax/settings/base_settings.dart';
import 'package:stax/rebase/rebase_data_setting.dart';

class RebaseSettings extends BaseSettings {
  late final RebaseDataSetting rebaseData = RebaseDataSetting(
    'rebase_data',
    null,
    this,
    'Data for resumable rebase operations',
  );

  static RebaseSettings? load(Context context) {
    final root = context.getRepositoryRoot();
    if (root == null) return null;
    return RebaseSettings(
      path.join(
        root,
        '.git',
        'info',
        'stax',
        'rebase.json',
      ),
    );
  }

  RebaseSettings(super.path) : super.fromPath();
}
