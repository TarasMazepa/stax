import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:stax/context/context_git_get_repository_root.dart';
import 'package:stax/context/context.dart';

class RepositorySettings {
  static RepositorySettings? _instance;

  static RepositorySettings? getInstanceFromContext(Context context) {
    final root = context.getRepositoryRoot();
    if (root == null) return null;
    return _instance ??= _load(root);
  }

  static RepositorySettings _load(String repositoryRoot) {
    return RepositorySettings(
      _loadJsonFile(_getConfigFile(repositoryRoot)),
      repositoryRoot,
    );
  }

  static Map<String, dynamic> _loadJsonFile(File file) {
    dynamic error = Exception('Unknown error');
    for (int i = 0; i < 3; i++) {
      if (!file.existsSync()) {
        file.createSync(recursive: true);
        file.writeAsStringSync('{}', flush: true);
      }
      try {
        return jsonDecode(file.readAsStringSync());
      } catch (e) {
        file.deleteSync();
        error = e;
      }
    }
    throw error;
  }

  static File _getConfigFile(String repositoryRoot) {
    return File.fromUri(
      path.toUri(
        path.join(repositoryRoot, '.git', 'info', 'stax', 'settings.json'),
      ),
    );
  }

  final String repositoryRoot;

  final Map<String, dynamic> settings;

  RepositorySettings(this.settings, this.repositoryRoot);

  String? operator [](String key) {
    final value = settings[key];
    return value is String ? value : null;
  }

  void operator []=(String key, String? value) {
    settings[key] = value;
  }

  void save() {
    _getConfigFile(repositoryRoot)
        .writeAsStringSync(jsonEncode(settings), flush: true);
  }
}
