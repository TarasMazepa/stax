import 'dart:io';

import 'package:test/test.dart';

import 'base/cli_group.dart';

void main() {
  cliGroup("single_commit", (setup) {
    test("ls", () {
      expect(
          Process.runSync("ls", [], workingDirectory: setup.testRepoPath)
              .stdout
              .toString()
              .trim(),
          "readme.md");
    });
    test("log", () {
      expect(
          Process.runSync(setup.liveStaxPath, ["log"],
                  workingDirectory: setup.testRepoPath)
              .stdout
              .toString()
              .trim(),
          "* [465015f] main Adds readme");
    });
  });
}
