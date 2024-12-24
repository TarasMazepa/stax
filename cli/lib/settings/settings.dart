import 'dart:convert';
import 'dart:io';

class Settings {
  static Settings? _instance;
  static Settings get instance => _instance ??= Settings._();

  final Map<String, String> settings = {};
  final File _settingsFile = File(
    '${Platform.environment['HOME'] ?? Platform.environment['USERPROFILE']}/.stax/settings.json',
  );

  Settings._() {
    _loadSettings();
  }

  void _loadSettings() {
    if (_settingsFile.existsSync()) {
      final jsonString = _settingsFile.readAsStringSync();
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      settings.addAll(Map<String, String>.from(jsonMap));
    }
  }

  void _saveSettings() {
    if (!_settingsFile.existsSync()) {
      _settingsFile.parent.createSync(recursive: true);
    }
    _settingsFile.writeAsStringSync(json.encode(settings));
  }

  void setSetting(String key, String value) {
    settings[key] = value;
    _saveSettings();
  }

  void removeSetting(String key) {
    settings.remove(key);
    _saveSettings();
  }
}
