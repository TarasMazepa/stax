import 'dart:convert';
import 'dart:io';

import 'package:cli_util/cli_util.dart';
import 'package:path/path.dart' as path;
import 'package:stax/settings/date_time_setting.dart';
import 'package:stax/settings/string_setting.dart';

class Settings {
  static Settings _load() {
    return Settings(_loadJsonFile(_globalConfigFile));
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

  static final _globalConfigFile = File.fromUri(
    path.toUri(path.join(applicationConfigHome('stax'), '.stax_config')),
  );

  static final instance = _load();

  final Map<String, dynamic> settings;

  late final DateTimeSetting lastUpdatePrompt = DateTimeSetting(
    'last_update_prompt',
    DateTime.now(),
    this,
    'Last time update was prompted',
  );

  late final StringSetting branchPrefix = StringSetting(
    'branch_prefix',
    '',
    this,
    'Prefix to add to all new branch names (e.g., "feature/")',
  );

  late final StringSetting defaultBranch = StringSetting(
    'default_branch',
    '',
    this,
    'Override for default branch (empty means use <remote>/HEAD)',
  );

  late final StringSetting defaultRemote = StringSetting(
    'default_remote',
    '',
    this,
    'Override for default remote (empty means use first available remote)',
  );

  Settings(this.settings);

  String? operator [](String key) {
    final value = settings[key];
    return value is String ? value : null;
  }

  void operator []=(String key, String? value) {
    settings[key] = value;
  }

  void save() {
    _globalConfigFile.writeAsStringSync(jsonEncode(settings), flush: true);
  }
}
