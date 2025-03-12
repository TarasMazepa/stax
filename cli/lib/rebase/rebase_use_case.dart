import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_repository_root.dart';
import 'package:stax/rebase/rebase_data.dart';

class RebaseUseCase {
  final Context context;
  RebaseData? _rebaseData;

  RebaseData? get rebaseDate => _rebaseData;

  static RebaseUseCase? create(Context context) {
    final repositoryRoot = context.withSilence(true).getRepositoryRoot();
    if (repositoryRoot == null) return null;
    final file = File(
      path.join(
        repositoryRoot,
        '.git',
        'info',
        'stax',
        'rebase.json',
      ),
    );
    if (!file.existsSync()) {
      return RebaseUseCase(context, null);
    }
    for (int i = 0; i < 3; i++) {
      try {
        return RebaseUseCase(
          context,
          RebaseData.fromJson(jsonDecode(file.readAsStringSync())),
        );
      } catch (e) {
        try {
          file.deleteSync();
        } catch (e) {
          // no op
        }
      }
    }
    return RebaseUseCase(context, null);
  }

  RebaseUseCase(this.context, this._rebaseData);
}
