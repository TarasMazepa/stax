import 'dart:io';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:test/test.dart';

void main() {
  test('isInsideWorkTree handles caching correctly', () {
    final tempDir = Directory.systemTemp.createTempSync();
    try {
      final context = Context.implicit().withWorkingDirectory(tempDir.path);

      expect(context.isInsideWorkTree(), false);

      context.command(['git', 'init']).runSync();

      // Because the result is cached statically, the second call will still return false.
      expect(context.isInsideWorkTree(), false);
    } finally {
      tempDir.deleteSync(recursive: true);
    }
  });
}
