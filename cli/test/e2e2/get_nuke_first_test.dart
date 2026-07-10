import 'package:test/test.dart';

import 'base/e2e2_group.dart';

Future<void> dirtyRepository(E2e2Container container) async {
  final result = await container.exec([
    'sh',
    '-c',
    'echo modified > tracked.txt && echo untracked > untracked.txt',
  ]);
  expect(result.exitCode, 0, reason: 'Failed to dirty the repository');
}

Future<String> status(E2e2Container container) async {
  final result = await container.exec(['git', 'status', '--porcelain']);
  expect(result.exitCode, 0);
  return (result.stdout as String).trim();
}

void main() {
  e2e2Group('get --nuke-first', onPlatform: const {}, (containerGetter) {
    test('nukes dirty working directory before getting a branch', () async {
      final container = containerGetter();
      await dirtyRepository(container);
      expect(await status(container), isNotEmpty);

      final result = await container.stax(['get', '--nuke-first', 'feature']);
      expect(result.exitCode, 0, reason: result.stderr.toString());

      expect(await status(container), isEmpty);
      final currentBranch = await container.exec([
        'git',
        'branch',
        '--show-current',
      ]);
      expect((currentBranch.stdout as String).trim(), 'feature');
    });

    test('short flag -n behaves the same as --nuke-first', () async {
      final container = containerGetter();
      await dirtyRepository(container);

      final result = await container.stax(['get', '-n', 'feature']);
      expect(result.exitCode, 0, reason: result.stderr.toString());

      expect(await status(container), isEmpty);
    });

    test('without the flag dirty files are left alone', () async {
      final container = containerGetter();
      await dirtyRepository(container);

      await container.stax(['get', 'feature']);

      expect(await status(container), isNotEmpty);
    });
  });
}
