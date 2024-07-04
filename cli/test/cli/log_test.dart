import 'dart:io';

import 'package:stax/commit_tree_for_test_case.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'base/cli_group.dart';

void main() {
  cliGroup("log", (setup) {
    test("empty", () {
      setup.runSync("git", ["init"]);
      expect(setup.runLiveStaxSync(["log"]).stdout, "");
    });
    var commitTree = CommitTreeForTestCase();
    for (int i = 0; i < 3; i++, commitTree = commitTree.next()) {
      final targetCommands = commitTree.getTargetCommands();
      final targetOutput = commitTree.getTargetOutput();
      final defaultBranch = commitTree.commitName(commitTree.mainId);
      test(commitTree.commitName(0), () {
        for (final value in targetCommands) {
          final parts = value.split(" ");
          if (parts[0] == "stax") {
            setup.runLiveStaxSync(parts.sublist(1));
          } else if (Platform.isWindows && parts[0] == "echo") {
            setup.runSync("powershell", ["-c", ...parts]);
          } else if (parts[0] == "echo") {
            setup.runSync("touch", [parts.last]);
          } else {
            setup.runSync(parts[0], parts.sublist(1));
          }
        }
        expect(
            setup.runLiveStaxSync([
              "log",
              "--default-branch",
              defaultBranch,
            ]).stdout,
            "${targetOutput.join("\n")}\n");
      });
    }
  });
}
