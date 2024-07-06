import 'dart:math';

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
    final random = Random();
    for (int i = 0; i < 10; i++, commitTree = commitTree.next()) {
      final skip = random.nextInt(pow(10, i) as int);
      for (int j = 0; j < skip; j++, commitTree = commitTree.next());
      final targetOutput = commitTree.getTargetOutput();
      final defaultBranch = commitTree.commitName(commitTree.mainId);
      final commitName = commitTree.commitName(0);
      test(commitName, () {
        setup.runLiveStaxSync(["log-test-case", commitName]);
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
