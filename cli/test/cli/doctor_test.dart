import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'base/cli_group.dart';

void main() {
  cliGroup('doctor', (setup) {
    test('doctor', () {
      final result = setup.runLiveStaxSync(['doctor']);
      expect(result.exitCode, 0);
      expect(result.stdout.toString(), contains('git config --get user.name'));
      expect(result.stdout.toString(), contains('git config --get user.email'));
    });
  });
}
