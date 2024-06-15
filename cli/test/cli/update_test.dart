import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'base/cli_group.dart';

void main() {
  cliGroup("update", (setup) {
    test("update", () {
      expect(setup.runLiveStaxSync(["update"]).stdout, """

Please refer to the most recent installation instructions in the repository README file for accurate and up-to-date information. You can find the installation section here: https://github.com/TarasMazepa/stax?tab=readme-ov-file#installation

""");
    }, onPlatform: {"windows": Skip("update still works on windows")});
  });
}
