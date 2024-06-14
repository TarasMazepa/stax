import 'package:stax/external_command/process_result_getters.dart';
import 'package:test/test.dart';

import 'base/cli_group.dart';
import 'base/cli_test_setup.dart';

void main() {
  cliGroup("single_commit", bundle: true, (CliTestSetup setup) {
    test("ls", () {
      expect(setup.runSync("ls").stdoutString, "readme.md\n");
    }, onPlatform: {
      "windows": [Skip("ls doesn't work on windows")]
    });
    test("log", () {
      expect(setup.runLiveStaxSync(["log"]).stdoutString, "o main\n");
    });
    test("commit 'commit message'", () async {
      await setup
          .startLiveStax(["commit", "commit message"]).then((process) async {
        await process.stdout.forEach((element) async {
          final line = String.fromCharCodes(element);
          print(line);
          if (line.contains(
              "You do not have any staged changes. Do you want to add all? Continue y/N?")) {
            process.stdin.writeln("y");
            await process.stdin.flush();
          }
        });
      });
    });
  });
}
