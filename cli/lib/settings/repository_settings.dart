import 'package:path/path.dart' as path;
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_repository_root.dart';
import 'package:stax/settings/base_settings.dart';
import 'package:stax/settings/rebase_data_setting.dart';

class RepositorySettings extends BaseSettings {
  late final RebaseDataSetting rebaseData = RebaseDataSetting(
    'rebase_data',
    null,
    this,
    'Data for resumable rebase operations',
  );

  static RepositorySettings? load(Context context) {
    final root = context.getRepositoryRoot();
    if (root == null) return null;

    final settingsPath = path.join(
      root,
      '.git',
      'info',
      'stax',
      'settings.json',
    );
  }

  RepositorySettings(super.path) : super.fromPath();
}
