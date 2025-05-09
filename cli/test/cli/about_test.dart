import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'base/cli_group.dart';

void main() {
  cliGroup('about', (setup) {
    test('about', () {
      expect(
        setup.runLiveStaxSync(['about']).stdout,
        '''stax - A Git workflow tool

stax is a command-line tool that helps you manage your Git workflow more efficiently.
It provides a set of commands to simplify common Git operations and maintain a clean repository structure.

For more information, visit: https://staxforgit.com/
''',
      );
    });
  });
}
