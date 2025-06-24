import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_repository_root.dart';
import 'package:stax/settings/base_settings.dart';
import 'package:stax/settings/key_value_store.dart';
import 'package:stax/settings/settings.dart';

class RepositorySettings extends KeyValueStore with BaseSettings {
  static RepositorySettings? load(Context context, Settings settings) {
    final root = context.withQuiet(true).getRepositoryRoot();
    if (root == null) return null;
    return RepositorySettings(
      path.join(
        Uri.directory(root, windows: Platform.isWindows).toFilePath(),
        '.git',
        'info',
        'stax',
        'settings.json',
      ),
      settings,
    );
  }

  final Settings _settings;

  RepositorySettings(super.path, this._settings) : super.fromPath();

  @override
  String? operator [](String key) {
    return super[key] ?? _settings[key];
  }
}
