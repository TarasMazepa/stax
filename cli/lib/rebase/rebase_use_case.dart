import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_default_branch.dart';
import 'package:stax/context/context_git_get_repository_root.dart';
import 'package:stax/context/context_git_log_all.dart';
import 'package:stax/file/file_read_as_string_sync_with_retry.dart';
import 'package:stax/file/file_system_entity_delete_sync_silently.dart';
import 'package:stax/file/file_write_as_string_sync_with_retry.dart';
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
    try {
      return RebaseUseCase(
        context,
        RebaseData.fromJson(jsonDecode(file.readAsStringSyncWithRetry())),
        file,
      );
    } catch (_) {
      file.deleteSyncSilently();
    }
    return RebaseUseCase(context, null, file);
  }

  RebaseUseCase(this.context, this._rebaseData, this._file);

  void initiate(bool hasTheirsFlag, bool hasOursFlag, String? rebaseOnto) {
    if (_rebaseData != null) throw Exception('Rebase is already in progress');

    final root = context.gitLogAll();

    final current = root.findCurrent();

    if (current == null) {
      throw Exception('Can find current branch.');
    }

    GitLogAllNode? targetNode;

    rebaseOnto ??= context.getDefaultBranch();

    if (rebaseOnto != null) {
      targetNode = root.findAnyRefThatEndsWith(rebaseOnto);
      if (targetNode == null) {
        throw Exception(
          "Can't find target branch which ends with user provided '$rebaseOnto'.",
        );
      }
    } else {
      targetNode = root.findRemoteHead();
    }

    if (targetNode == null) {
      throw Exception("Can't find target branch.");
    }

    _rebaseData = RebaseData(
      hasTheirsFlag,
      hasOursFlag,
      targetNode.line.branchNameOrCommitHash(),
      current.localBranchNamesInOrderForRebase().toList(),
      0,
    );

    save();
  }

  void continueRebase() {
    while (shouldContinueRebase()) {
      executeNextRebaseStep();
    }
  }

  bool shouldContinueRebase() {
    return _rebaseData != null;
  }

  void executeNextRebaseStep() {
    final rebaseData = assertRebaseData;
    try {
      final rebaseStep = rebaseData.currentStep;
      final exitCode =
          context.git.rebase
              .args([
                if (rebaseData.hasTheirsFlag) ...['-X', 'theirs'],
                if (rebaseData.hasOursFlag) ...['-X', 'ours'],
                if (rebaseData.index == 0)
                  rebaseData.rebaseOnto
                else
                  rebaseStep.parent!,
                rebaseStep.node,
              ])
              .announce()
              .runSync()
              .printNotEmptyResultFields()
              .exitCode;
      if (exitCode != 0) {
        throw Exception('Rebase failed');
      }
      context.git.pushForce.announce().runSync().printNotEmptyResultFields();
    } finally {
      rebaseData.index++;
      save();
    }
  }

  void save() {
    RebaseData? rebaseData = _rebaseData;
    if (rebaseData?.index == rebaseData?.steps.length) {
      rebaseData = _rebaseData = null;
    }
    if (rebaseData == null) {
      _file.deleteSyncSilently();
      return;
    }
    _file.writeAsStringSyncWithRetry(jsonEncode(rebaseData.toJson()));
  }

  void assertRebaseInProgress() {
    if (_rebaseData == null) throw Exception('No rebase in progress.');
  }

  void abort() {
    _rebaseData = null;
    save();
  }
}
