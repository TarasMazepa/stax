import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

class BaseSettings {
  final Map<String, dynamic> _settings;
  final File _file;

  BaseSettings(this._settings, this._file);

  BaseSettings.fromFile(File file)
      : this(readJsonSettingsFileAsStringSyncWithRetry(file), file);

  BaseSettings.fromUri(Uri uri) : this.fromFile(File.fromUri(uri));

  BaseSettings.fromPath(String path) : this.fromUri(p.toUri(path));

  static Map<String, dynamic> readJsonSettingsFileAsStringSyncWithRetry(
    File file,
  ) {
    dynamic error;
    for (int i = 0; i < 3; i++) {
      try {
        if (!file.existsSync()) {
          file.createSync(recursive: true);
          file.writeAsStringSync('{}', flush: true);
        }
        return jsonDecode(file.readAsStringSync());
      } catch (e) {
        file.deleteSync();
        error ??= e;
      }
    }
    throw error;
  }

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
