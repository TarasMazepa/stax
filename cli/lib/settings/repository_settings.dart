import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:stax/context/context_git_get_repository_root.dart';
import 'package:stax/context/context.dart';
import 'package:stax/settings/uri_load_settings.dart';

class RepositorySettings {
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

  final Map<String, dynamic> _settings;
  final File _file;

  RepositorySettings(this._settings, this._file);

  String? operator [](String key) {
    final value = _settings[key];
    return value is String ? value : null;
  }

  void operator []=(String key, String? value) {
    _settings[key] = value;
  }

  void save() {
    _file.writeAsStringSync(jsonEncode(_settings), flush: true);
  }
}
