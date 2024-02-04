import 'package:test/test.dart';

import 'base/cli_group.dart';
import 'base/cli_test_setup.dart';

void main() {
  cliGroup("single_commit", (CliTestSetup setup) {
    test("ls", () {
      expect(setup.runSync("ls").stdout.toString().trim(), "readme.md");
    });
    test("log", () {
      expect(setup.runLiveStaxSync(["log"]).stdout.toString().trim(), "* main");
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
