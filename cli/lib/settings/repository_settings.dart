import 'package:path/path.dart' as path;
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_repository_root.dart';
import 'package:stax/settings/base_settings.dart';

class RepositorySettings extends BaseSettings {
  static RepositorySettings? load(Context context) {
    final root = context.getRepositoryRoot();
    if (root == null) return null;
    return RepositorySettings(
      path.join(Uri.parse(root).toFilePath(),
      '.git',
      'info',
      'stax',
      'settings.json',
      ),
    );
  }

  RepositorySettings(super.path) : super.fromPath();
}
