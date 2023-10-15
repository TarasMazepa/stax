import 'dart:io';

import 'package:test/test.dart';

import 'base/cli_group.dart';

void main() {
  cliGroup("single_commit", (path) {
    test("ls", () {
      expect(
          Process.runSync("ls", [path]).stdout.toString().trim(), "readme.md");
    });
  });
}
