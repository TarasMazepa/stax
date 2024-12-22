import 'package:stax/string_empty_to_null.dart';
import 'package:test/test.dart';

import 'base/cli_group.dart';
import 'base/cli_test_setup.dart';

void main() {
  List<String> getSuccessFailMarkForDoctorOutput(dynamic out) {
    return out
        .toString()
        .split('\n')
        .where((x) => x.length > 1 && x[0] == '[')
        .map((x) => x[1])
        .toList();
  }

  cliGroup('doctor', bundle: true, (CliTestSetup setup) {
    test('doctor', () {
      final defaultGlobalUsername = setup
          .runSync('git', ['config', '--get', 'user.name'])
          .stdout
          .toString()
          .trim()
          .emptyToNull();
      final defaultGlobalEmail = setup
          .runSync('git', ['config', '--get', 'user.email'])
          .stdout
          .toString()
          .trim()
          .emptyToNull();
      final defaultGlobalAutoRemote = setup
          .runSync('git', ['config', '--get', 'push.autoSetupRemote'])
          .stdout
          .toString()
          .trim()
          .emptyToNull();
      List<String> expectedOutput = [
        defaultGlobalUsername == null ? 'X' : 'V',
        defaultGlobalEmail == null ? 'X' : 'V',
        defaultGlobalAutoRemote == null ? 'X' : 'V',
        'V',
        'X',
      ];

      expect(
        getSuccessFailMarkForDoctorOutput(
          setup.runLiveStaxSync(['doctor']).stdout,
        ),
        expectedOutput,
      );

      expectedOutput[3] = 'X';

      setup.runSync('git', ['remote', 'rm', 'origin']);

      expect(
        getSuccessFailMarkForDoctorOutput(
          setup.runLiveStaxSync(['doctor']).stdout,
        ),
        expectedOutput,
      );
    });
  });
}
