import 'dart:convert';
import 'dart:io';

class BaseSettings {
  final Map<String, dynamic> _settings;
  final File _file;

  BaseSettings(this._settings, this._file);

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
