import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'base/cli_group.dart';

void main() {
  cliGroup('update', (setup) {
    test(
      'update on linux',
      () {
        expect(setup.runLiveStaxSync(['update']).stdout.toString(),
            '''Checking if stax is installed via Homebrew...
Homebrew is not installed on this system.

Please refer to the most recent installation instructions in the repository README file for accurate and up-to-date information. You can find the installation section here: https://github.com/TarasMazepa/stax?tab=readme-ov-file#installation

''');
      },
      testOn: 'linux',
    );

    test(
      'update on macos',
      () {
        expect(setup.runLiveStaxSync(['update']).stdout.toString(),
            '''Checking if stax is installed via Homebrew...
stax is not installed via Homebrew on this system.

Please refer to the most recent installation instructions in the repository README file for accurate and up-to-date information. You can find the installation section here: https://github.com/TarasMazepa/stax?tab=readme-ov-file#installation

''');
      },
      testOn: 'mac-os',
    );

    test(
      'update on Windows',
      () {
        expect(setup.runLiveStaxSync(['update']).stdout.toString(), '''

Please refer to the most recent installation instructions in the repository README file for accurate and up-to-date information. You can find the installation section here: https://github.com/TarasMazepa/stax?tab=readme-ov-file#installation

''');
      },
      testOn: 'windows',
    );
  });
}
