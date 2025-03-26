import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:stax/file/file_read_as_string_sync_with_retry.dart';
import 'package:stax/file/file_system_entity_delete_sync_silently.dart';
import 'package:stax/file/file_write_as_string_sync_with_retry.dart';

class KeyValueStore {
  final Map<String, dynamic> _settings;
  final File _file;

  KeyValueStore(this._settings, this._file);

  KeyValueStore.fromFile(File file)
    : this(readJsonSettingsFileAsStringSyncWithRetry(file), file);

  KeyValueStore.fromUri(Uri uri) : this.fromFile(File.fromUri(uri));

  KeyValueStore.fromPath(String path) : this.fromUri(p.toUri(path));

  static Map<String, dynamic> readJsonSettingsFileAsStringSyncWithRetry(
    File file,
  ) {
    Map<String, dynamic> createEmptySettingsFileIfNeededAndRead() {
      if (!file.existsSync()) {
        file.createSync(recursive: true);
        file.writeAsStringSyncWithRetry('{}');
      }
      return jsonDecode(file.readAsStringSyncWithRetry());
    }

    try {
      return createEmptySettingsFileIfNeededAndRead();
    } catch (_) {
      file.deleteSyncSilently();
      return createEmptySettingsFileIfNeededAndRead();
    }
  }

  String? operator [](String key) {
    final value = _settings[key];
    return value is String ? value : null;
  }

  void operator []=(String key, String? value) {
    _settings[key] = value;
  }

  void save() {
    _file.writeAsStringSyncWithRetry(jsonEncode(_settings));
  }
}
