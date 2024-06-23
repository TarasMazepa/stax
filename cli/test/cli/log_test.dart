import 'dart:io';

import 'package:stax/commit_tree_for_test_cases.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'base/cli_group.dart';

void main() {
  cliGroup("log", (setup) {
    test("empty", () {
      print(setup.runSync("git", ["init"]).stdout);
      expect(setup.runLiveStaxSync(["log"]).stdout,
          "your repository has no branches\n");
    });
    var commitTree = CommitTreeForTestCases();
    for (int i = 0; i < 1; i++, commitTree = commitTree.next()) {
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
        print(setup.runSync("git", ["log"]).stdout);
        print(setup.runSync("git", ["log"]).stderr);
        final result = setup.runLiveStaxSync([
          "log",
          "--loud",
          "--default-branch",
          defaultBranch,
        ]);
        print(result.stdout);
        print(result.stderr);
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
