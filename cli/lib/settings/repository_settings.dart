import 'package:path/path.dart' as path;
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_repository_root.dart';
import 'package:stax/settings/base_settings.dart';

class RepositorySettings extends BaseSettings {
  static RepositorySettings? _instance;

  static RepositorySettings? getInstanceFromContext(Context context) {
    final root = context.getRepositoryRoot();
    if (root == null) return null;
    return _instance ??= RepositorySettings(
      path.join(
        Uri.parse(root).toFilePath(),
        '.git/info/stax/settings.json',
      ),
    );
  }

  RepositorySettings(super.path) : super.fromPath();
}
