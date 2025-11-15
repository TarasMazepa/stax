import 'package:test/test.dart';

import '../string_clean_carrige_return_on_windows.dart';
import 'base/cli_group.dart';
import 'base/cli_test_setup.dart';

void main() {
  cliGroup('single_commit', bundle: true, (CliTestSetup setup) {
    test(
      'ls',
      () {
        expect(setup.runSync('ls').stdout, 'readme.md\n');
      },
      onPlatform: {
        'windows': [Skip("ls doesn't work on windows")],
      },
    );
    test('log', () {
      expect(
        setup
            .runLiveStaxSync(['log'])
            .stdout
            .toString()
            .cleanCarriageReturnOnWindows(),
        'x origin/main, origin/HEAD, main\n',
      );
    });
    test("commit 'commit message'", () async {
      await setup.startLiveStax(['commit', 'commit message']).then((
        process,
      ) async {
        await process.stdout.forEach((element) async {
          final line = String.fromCharCodes(element);
          print(line);
          if (line.contains(
            'You do not have any staged changes. Do you want to add all? Continue y/N?',
          )) {
            process.stdin.writeln('y');
            await process.stdin.flush();
          }
        });
      });
    });
  });
}
