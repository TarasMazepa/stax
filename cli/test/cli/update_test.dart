import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'base/cli_group.dart';

void main() {
  cliGroup('update', (setup) {
    test(
      'update on linux',
      () {
        final output = setup.runLiveStaxSync(['update']).stdout;

        final expectedLines = [
          'Checking if stax is installed via Homebrew...',
          'Homebrew is not installed on this system.',
          'Please refer to the most recent installation instructions in the repository README file for accurate and up-to-date information. You can find the installation section here: https://github.com/TarasMazepa/stax?tab=readme-ov-file#installation',
        ];

        final actualLines = output
            .split('\n')
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty == true)
            .toList();

        expect(actualLines, expectedLines);
      },
      onPlatform: {
        'windows': Skip('This test is for linux'),
        'mac-os': Skip('This test is for linux'),
      },
    );

    test(
      'update on macos',
      () {
        final output = setup.runLiveStaxSync(['update']).stdout;

        final expectedLines = [
          'Checking if stax is installed via Homebrew...',
          'stax is not installed via Homebrew on this system.',
          'Please refer to the most recent installation instructions in the repository README file for accurate and up-to-date information. You can find the installation section here: https://github.com/TarasMazepa/stax?tab=readme-ov-file#installation',
        ];

        final actualLines = output
            .split('\n')
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty == true)
            .toList();

        expect(actualLines, expectedLines);
      },
      onPlatform: {
        'windows': Skip('This test is for macos'),
        'linux': Skip('This test is for macos'),
      },
    );

    test(
      'update on Windows',
      () {
        final output = setup.runLiveStaxSync(['update']).stdout;

        final expectedLines = [
          'Please refer to the most recent installation instructions in the repository README file for accurate and up-to-date information. You can find the installation section here: https://github.com/TarasMazepa/stax?tab=readme-ov-file#installation',
        ];

        final actualLines = output
            .split('\n')
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty == true)
            .toList();

        expect(actualLines, expectedLines);
      },
      onPlatform: {
        'linux': Skip('This test is for Windows platforms'),
        'mac-os': Skip('This test is for Windows platforms'),
      },
    );
  });
}
