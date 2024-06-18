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
      List<String> expectedOutput = ["V", "V", "V", "V"];

      expect(
          praseDoctorOutput(
              setup.runLiveStaxSync(["doctor"]).stdout.toString().trim()),
          expectedOutput);

      expectedOutput = ["V", "V", "V", "X"];

      setup.runSync("git", ["remote", "rm", "origin"]);

      expect(
          praseDoctorOutput(
              setup.runLiveStaxSync(["doctor"]).stdout.toString().trim()),
          expectedOutput);
    });
  });
}
