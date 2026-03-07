import 'dart:io';

import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:test/test.dart';

class MockContext extends Context {
  final List<String> log = [];

  MockContext(String? workingDirectory)
    : super(false, workingDirectory, false, false, false);

  @override
  void printToConsole(Object? object) {
    log.add(object.toString());
  }
}

void main() {
  group('ContextGitIsInsideWorkTree', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('stax_test_');
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test('explainToUserNotInsideGitWorkTree prints the correct message', () {
      final context = MockContext(null);
      context.explainToUserNotInsideGitWorkTree();
      expect(
        context.log.any(
          (line) => line.contains('You are not inside git work tree.'),
        ),
        isTrue,
      );
    });

    test('handleNotInsideGitWorkingTree prints when not inside work tree', () {
      // Create a directory that is definitely not a git repo
      final context = MockContext(tempDir.path);
      final result = context.handleNotInsideGitWorkingTree();

      expect(result, isTrue);
      expect(
        context.log.any(
          (line) => line.contains('You are not inside git work tree.'),
        ),
        isTrue,
      );
    });

    test('isInsideWorkTree returns true when inside a git work tree', () {
      Process.runSync('git', ['init'], workingDirectory: tempDir.path);
      final context = Context.implicit().withWorkingDirectory(tempDir.path);
      expect(context.isInsideWorkTree(), isTrue);
    });

    test('isInsideWorkTree returns false when not inside a git work tree', () {
      final context = Context.implicit().withWorkingDirectory(tempDir.path);
      expect(context.isInsideWorkTree(), isFalse);
    });

    test(
      'handleNotInsideGitWorkingTree returns false when inside work tree',
      () {
        Process.runSync('git', ['init'], workingDirectory: tempDir.path);
        final context = MockContext(tempDir.path);
        final result = context.handleNotInsideGitWorkingTree();

        expect(result, isFalse);
        expect(
          context.log.any(
            (line) => line.contains('You are not inside git work tree.'),
          ),
          isFalse,
        );
      },
    );
  });
}
