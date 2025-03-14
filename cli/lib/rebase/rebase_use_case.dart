import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_repository_root.dart';
import 'package:stax/file/file_system_entity_delete_sync_silently.dart';
import 'package:stax/rebase/rebase_data.dart';

class RebaseUseCase {
  final Context context;
  RebaseData? _rebaseData;
  final File _file;

  RebaseData? get rebaseData => _rebaseData;

  RebaseData get assertRebaseData => _rebaseData!;

  static RebaseUseCase? create(Context context) {
    final repositoryRoot = context.withSilence(true).getRepositoryRoot();
    if (repositoryRoot == null) return null;
    final file = File(
      path.join(repositoryRoot, '.git', 'info', 'stax', 'rebase.json'),
    );
    if (!file.existsSync()) {
      return RebaseUseCase(context, null, file);
    }
    for (int i = 0; i < 3; i++) {
      try {
        return RebaseUseCase(
          context,
          RebaseData.fromJson(jsonDecode(file.readAsStringSync())),
          file,
        );
      } catch (_) {
        file.deleteSyncSilently();
      }
    }
    return RebaseUseCase(context, null, file);
  }

  RebaseUseCase(this.context, this._rebaseData, this._file);

  void initiate(RebaseData rebaseData) {
    if (_rebaseData != null) throw StateError('Rebase is already in progress');
    _rebaseData = rebaseData;
    save();
  }

  void save() {
    final rebaseData = _rebaseData;
    if (rebaseData == null) {
      _file.deleteSyncSilently();
      return;
    }
    _file.writeAsStringSync(jsonEncode(rebaseData.toJson()));
  }
}
