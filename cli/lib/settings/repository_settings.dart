import 'package:path/path.dart' as path;
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_repository_root.dart';
import 'package:stax/settings/base_settings.dart';
import 'package:stax/settings/uri_load_settings.dart';

class RepositorySettings extends BaseSettings {
  static RepositorySettings? _instance;

  static RepositorySettings? getInstanceFromContext(Context context) {
    final root = context.getRepositoryRoot();
    if (root == null) return null;
    return _instance ??= path
        .toUri(
          path.join(
            Uri.parse(root).toFilePath(),
            '.git/info/stax/settings.json',
          ),
        )
        .loadSettings(RepositorySettings.new);
  }

  RepositorySettings(super._settings, super._file);
}
