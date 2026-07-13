import 'package:test/test.dart';

import 'base/e2e_interactive_group.dart';

void main() {
  e2eInteractiveGroup('get --nuke-first', (setup) {
    Future<String> status() async {
      final result = await setup.run('git', ['status', '--porcelain']);
      expect(result.exitCode, 0, reason: result.stderr.toString());
      return (result.stdout as String).trim();
    }

    Future<String> currentBranch() async {
      final result = await setup.run('git', ['branch', '--show-current']);
      expect(result.exitCode, 0, reason: result.stderr.toString());
      return (result.stdout as String).trim();
    }

    test('nukes dirty working directory before getting a branch', () async {
      expect(await status(), '''M tracked.txt
?? untracked.txt''');

      final result = await setup.runStax(['get', '--nuke-first', 'feature']);
      expect(result.exitCode, 0, reason: result.stderr.toString());

      expect(await status(), isEmpty);
      expect(await currentBranch(), 'feature');
    });

    test('without the flag dirty files are left alone', () async {
      final result = await setup.runStax(['get', 'feature']);
      expect(result.exitCode, 0, reason: result.stderr.toString());

      expect(await status(), '''M tracked.txt
?? untracked.txt''');
    });
  });
}
