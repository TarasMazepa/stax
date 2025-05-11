import 'dart:io';
import 'dart:convert';

import 'package:stax/command/flag.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_repository_root.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';
import 'package:stax/log/decorated/decorated_log_line_producer.dart';
import 'package:path/path.dart' as path;

import 'internal_command.dart';

class InternalCommandLog extends InternalCommand {
  static final Flag defaultBranchFlag = Flag(
    short: '-d',
    long: '--default-branch',
    description: 'assume different default branch',
  );
  static final Flag allBranchesFlag = Flag(
    short: '-a',
    long: '--all',
    description: 'show remote branches also',
  );

  static final Flag watchFlag = Flag(
    short: '-w',
    long: '--watch',
    description: 'watch for git changes and re-run',
  );

  InternalCommandLog()
    : super(
        'log',
        'Shows a tree of all branches.',
        flags: [defaultBranchFlag, allBranchesFlag, watchFlag],
      );

  @override
  void run(List<String> args, Context context) async {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }
    context = context.withSilence(true);

    final String? defaultBranch;

    try {
      defaultBranch = defaultBranchFlag.getFlagValue(args);
    } catch (e) {
      print(e);
      return;
    }

    final showAllBranches = allBranchesFlag.hasFlag(args);
    final shouldWatch = watchFlag.hasFlag(args);

    print(
      materializeDecoratedLogLines(
        context.gitLogAll(showAllBranches),
        DecoratedLogLineProducerAdapterForGitLogAllNode(
          showAllBranches,
          defaultBranch,
        ),
      ).join('\n'),
    );

    if (!shouldWatch) return;
    final root = context.withSilence(true).getRepositoryRoot();

    if (root == null) return;
    print(context.getRepositoryRoot());
    final gitHead = path.join(
      Uri.directory(root, windows: Platform.isWindows).toFilePath(),
      '.git',
      'HEAD',
    );
    final gitRefs = path.join(
      Uri.directory(root, windows: Platform.isWindows).toFilePath(),
      '.git',
      'refs',
    );
    final gitObjects = path.join(
      Uri.directory(root, windows: Platform.isWindows).toFilePath(),
      '.git',
      'objects',
    );

    final watchList = [
      File(gitHead),
      Directory(gitRefs),
      Directory(gitObjects),
    ];

    for (final fileEntity in watchList) {
      if (await fileEntity.exists()) {
        if (fileEntity is File) {
          final parentDir = fileEntity.parent;
          final fileName = fileEntity.uri.pathSegments.last;

          parentDir.watch(recursive: true).listen((event) {
            if (event.path.endsWith(fileName)) {
              runStaxLog(context);
            }
          });
        } else if (fileEntity is Directory) {
          fileEntity.watch(recursive: true).listen((event) {
            runStaxLog(context);
          });
        }
      }
    }
  }

  void runStaxLog(Context context) async {
    print(Process.runSync('clear', [], runInShell: true).stdout);

    final result = context
        .command(['stax', 'log'])
        .runSync(
          runInShell: true,
          stdoutEncoding: const Utf8Codec(),
          stderrEncoding: const Utf8Codec(),
        );
    if (result.stdout != null) {
      print(result.stdout);
    }
  }
}
