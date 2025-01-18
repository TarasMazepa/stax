import 'dart:convert';
import 'dart:io';

import 'package:cli_util/cli_util.dart';
import 'package:path/path.dart' as path;
import 'package:stax/settings/date_time_setting.dart';
import 'package:stax/settings/string_setting.dart';
import 'package:stax/settings/uri_load_settings.dart';

class Settings {
  static final instance = path
      .toUri(path.join(applicationConfigHome('stax'), '.stax_config'))
      .loadSettings(Settings.new);

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

  final Map<String, dynamic> _settings;
  final File _file;

  Settings(this._settings, this._file);

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
