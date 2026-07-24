import 'package:test/test.dart';

import '../e2e_repository.dart';
import 'base/e2e_group.dart';

const int mergeCommitCount = 300;

const String expectedRepository = '/repo-expected';

const String stackTipBranch = 'feature-two';

void main() {
  e2eGroup(
    'rebase with many merge commits',
    timeout: const Timeout(Duration(minutes: 5)),
    (setup) {
      test('main is built out of merge commits', () async {
        final result = await setup.run('git', [
          '-C',
          defaultRepositoryPath,
          'rev-list',
          '--count',
          '--merges',
          'origin/main',
        ]);

        expect(int.parse((result.stdout as String).trim()), mergeCommitCount);
      });

      test('rebases stack onto main', () async {
        final stopwatch = Stopwatch()..start();
        final result = await setup.runStax(['rebase']);
        stopwatch.stop();

        expect(
          result.exitCode,
          0,
          reason: 'stax rebase failed: ${result.stderr}',
        );
        print(
          'stax rebase over $mergeCommitCount merge commits '
          'took ${stopwatch.elapsed.inMilliseconds}ms',
        );

        await expectSameRepositoryHistory(
          setup.run,
          expected: expectedRepository,
          revisions: const [stackTipBranch],
        );
        await expectCleanRepositoryFiles(setup.run);
      });
    },
  );
}
