import 'package:test/test.dart';

import 'base/cli_group.dart';
import 'base/cli_test_setup.dart';

void main() {
  cliGroup("single_commit", (CliTestSetup setup) {
    test("ls", () {
      expect(setup.runSync("ls").stdout.toString().trim(), "readme.md");
    });
    test("log", () {
      expect(setup.runLiveStaxSync(["log"]).stdout.toString().trim(),
          "* [465015f] main Adds readme");
    });
  });
}
