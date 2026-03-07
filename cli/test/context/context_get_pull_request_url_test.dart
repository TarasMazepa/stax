import 'dart:io';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_get_pull_request_url.dart';
import 'package:test/test.dart';

void main() {
  test('returns null when remote is missing', () {
    final tempDir = Directory.systemTemp.createTempSync('stax_test_');
    try {
      final context = Context.implicit().withWorkingDirectory(tempDir.path);
      context.command(['git', 'init']).runSync();

      final url = context.getPullRequestUrl('main', 'feature');
      expect(url, isNull);
    } finally {
      tempDir.deleteSync(recursive: true);
    }
  });

  test('returns expected URL when remote is present', () {
    final tempDir = Directory.systemTemp.createTempSync('stax_test_');
    try {
      final context = Context.implicit().withWorkingDirectory(tempDir.path);
      context.command(['git', 'init']).runSync();
      context.command(['git', 'remote', 'add', 'origin', 'git@github.com:example/repo.git']).runSync();

      final url = context.getPullRequestUrl('main', 'feature');
      expect(url, 'https://github.com/example/repo/compare/main...feature?expand=1');
    } finally {
      tempDir.deleteSync(recursive: true);
    }
  });
}
