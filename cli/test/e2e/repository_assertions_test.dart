import 'package:test/test.dart';

import '../e2e_repository.dart';
import 'base/e2e_group.dart';

const String sameRepository = '/repo-same';

const String dirtyRepository = '/repo-dirty';

const String aheadRepository = '/repo-ahead';

void main() {
  e2eGroup('repository', (setup) {
    test('history contains a line per commit', () async {
      final history = await repositoryHistory(setup.run);

      expect(history.split('\n'), hasLength(2));
      expect(history, contains('second commit'));
      expect(history, contains('first commit'));
    });

    test('history is limited by revisions', () async {
      final history = await repositoryHistory(setup.run, revisions: ['-1']);

      expect(history.split('\n'), hasLength(1));
      expect(history, contains('second commit'));
      expect(history, isNot(contains('first commit')));
    });

    test('history includes refs only when asked', () async {
      final withRefs = await repositoryHistory(setup.run, includeRefs: true);
      final withoutRefs = await repositoryHistory(
        setup.run,
        includeRefs: false,
      );

      expect(withRefs, contains('main'));
      expect(withoutRefs, isNot(contains('main')));
    });

    test('same history for a clone', () async {
      await expectSameRepositoryHistory(setup.run, expected: sameRepository);
    });

    test('same history ignores working tree changes', () async {
      await expectSameRepositoryHistory(setup.run, expected: dirtyRepository);
    });

    test('same history fails for an extra commit', () async {
      await expectLater(
        expectSameRepositoryHistory(setup.run, expected: aheadRepository),
        throwsA(isA<TestFailure>()),
      );
    });

    test('same history fails for a clone when refs are included', () async {
      await expectLater(
        expectSameRepositoryHistory(
          setup.run,
          expected: sameRepository,
          includeRefs: true,
        ),
        throwsA(isA<TestFailure>()),
      );
    });

    test('file diff is empty for a clean repository', () async {
      expect(await repositoryFileDiff(setup.run), isEmpty);
    });

    test('file diff reports modified and untracked files', () async {
      final diff = await repositoryFileDiff(
        setup.run,
        repository: dirtyRepository,
      );

      expect(diff, contains('a.txt'));
      expect(diff, contains('untracked.txt'));
    });

    test('file diff leaves the index unchanged', () async {
      await repositoryFileDiff(setup.run, repository: dirtyRepository);

      final status = await setup.run('git', [
        '-C',
        dirtyRepository,
        'status',
        '--porcelain',
      ]);
      expect(status.stdout, contains('?? untracked.txt'));
      expect(status.stdout, isNot(contains('A  untracked.txt')));
    });

    test('clean files for an untouched repository', () async {
      await expectCleanRepositoryFiles(setup.run);
    });

    test('clean files fails for a dirty repository', () async {
      await expectLater(
        expectCleanRepositoryFiles(setup.run, repository: dirtyRepository),
        throwsA(isA<TestFailure>()),
      );
    });

    test('same files for a clone', () async {
      await expectSameRepositoryFiles(setup.run, expected: sameRepository);
    });

    test('same files fails for a dirty repository', () async {
      await expectLater(
        expectSameRepositoryFiles(setup.run, expected: dirtyRepository),
        throwsA(isA<TestFailure>()),
      );
    });
  });
}
