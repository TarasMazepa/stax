import 'package:stax/string_empty_to_null.dart';
import 'package:test/test.dart';

import 'base/cli_group.dart';
import 'base/cli_test_setup.dart';

void main() {
  List<String> praseDoctorOutput(String out) {
    List<String> result = [];

    for (int i = 0; i < out.length; i++) {
      if (out[i] == "[" && out[i + 2] == "]") {
        result.add(out[i + 1]);
      }
    }

    return result;
  }

  cliGroup("doctor", bundle: true, (CliTestSetup setup) {
    test("doctor", () {
      final defaultGlobalUsername = setup
          .runSync("git", ["config", "--get", "user.name"])
          .stdout
          .toString()
          .trim()
          .emptyToNull();
      final defaultGobalEmail = setup
          .runSync("git", ["config", "--get", "user.email"])
          .stdout
          .toString()
          .trim()
          .emptyToNull();
      final defaultGlobalAutoRemote = setup
          .runSync("git", ["config", "--get", "push.autoSetupRemote"])
          .stdout
          .toString()
          .trim()
          .emptyToNull();
      List<String> expectedOutput = [
        defaultGlobalUsername == null ? "X" : "V",
        defaultGobalEmail == null ? "X" : "V",
        defaultGlobalAutoRemote == null ? "X" : "V",
        "V"
      ];

      expect(
          praseDoctorOutput(
              setup.runLiveStaxSync(["doctor"]).stdout.toString().trim()),
          expectedOutput);

      expectedOutput = [
        expectedOutput[0],
        expectedOutput[1],
        expectedOutput[2],
        "X"
      ];

      setup.runSync("git", ["remote", "rm", "origin"]);

      expect(
          praseDoctorOutput(
              setup.runLiveStaxSync(["doctor"]).stdout.toString().trim()),
          expectedOutput);
    });
  });
}
