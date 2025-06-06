import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:stax/context/context.dart';
import 'package:stax/file/file_system_entity_delete_sync_silently.dart';

import '../../test_file_original_path.dart';

class CliTestSetup {
  static final random = Random(DateTime.now().microsecondsSinceEpoch);
  final String testFile;
  final String? bundleFile;
  final String testRepoPath;
  final String liveStaxPath;

  CliTestSetup(
    this.testFile,
    this.bundleFile,
    this.testRepoPath,
    this.liveStaxPath,
  );

  factory CliTestSetup.create(bool bundle) {
    final uri = Uri.parse(assertTestFileUriString());
    final fileName = uri.toFilePath();
    final repoRoot = uri.replace(
      path: uri.path.substring(0, uri.path.indexOf('/cli/test/cli/')),
    );
    randomValue() {
      return '${DateTime.now().microsecondsSinceEpoch}${random.nextDouble()}';
    }

    final testRepo = repoRoot.replace(
      path: '${repoRoot.path}/cli/.test/${randomValue()}',
    );
    final liveStax = repoRoot.replace(
      path: "${repoRoot.path}/dev/stax${Platform.isWindows ? ".bat" : ""}",
    );
    return CliTestSetup(
      fileName,
      bundle
          ? fileName.replaceRange(
              fileName.length - 4 /* Length of 'dart' filename extension*/,
              fileName.length,
              'bundle',
            )
          : null,
      testRepo.toFilePath(),
      liveStax.toFilePath(),
    );
  }

  void setUp() {
    tearDown();
    final bundle = bundleFile;
    if (bundle != null) {
      Context.implicit().git.clone.args([bundle, testRepoPath]).runSync();
    } else {
      Directory(testRepoPath).createSync(recursive: true);
    }
  }

  void tearDown() {
    Directory(testRepoPath).deleteSyncSilently(recursive: true);
  }

  ProcessResult runSync(String command, [List<String>? args]) {
    return Process.runSync(
      command,
      args ?? [],
      workingDirectory: testRepoPath,
      stdoutEncoding: Platform.isWindows ? const Utf8Codec() : systemEncoding,
    );
  }

  ProcessResult runLiveStaxSync([List<String>? args]) {
    return runSync(liveStaxPath, args);
  }

  Future<Process> start(String command, [List<String>? args]) {
    return Process.start(command, args ?? [], workingDirectory: testRepoPath);
  }

  Future<Process> startLiveStax([List<String>? args]) {
    return start(liveStaxPath, args);
  }

  @override
  String toString() {
    return '$testFile $bundleFile $testRepoPath $liveStaxPath';
  }
}
