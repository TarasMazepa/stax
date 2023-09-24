import 'dart:convert';
import 'dart:io';

import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_repository_root.dart';
import 'package:stax/file_path_dir_on_uri.dart';
import 'package:stax/settings/date_time_setting.dart';

class Settings {
  static Settings _load() {
    dynamic error = Exception("Unknown error");
    for (int i = 0; i < 3; i++) {
      if (!_file.existsSync()) {
        _file.createSync();
        _file.writeAsStringSync("{}", flush: true);
      }
      try {
        final map = jsonDecode(_file.readAsStringSync());
        return Settings(map);
      } catch (e) {
        _file.deleteSync();
        error = e;
      }
    }
    throw error;
  }

  static final _rootPath = Context()
      .withSilence(true)
      .getRepositoryRoot(workingDirectory: Platform.script.toFilePathDir());

  static final _file = File("$_rootPath/.stax_settings");

  static final instance = _load();

  final Map<String, dynamic> settings;

  late final DateTimeSetting lastUpdatePrompt =
      DateTimeSetting("last_update_prompt", DateTime(2023), this);

  Settings(this.settings);

  String? operator [](String key) {
    final value = settings[key];
    return value is String ? value : null;
  }

  void operator []=(String key, String? value) {
    settings[key] = value;
  }

  void save() {
    _file.writeAsStringSync(jsonEncode(settings), flush: true);
  }
}
