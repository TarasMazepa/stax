import 'dart:io';

import 'package:stax/external_command/process_result_getters.dart';
import 'package:test/test.dart';

import 'base/cli_group.dart';

void main() {
  cliGroup("update", (setup) {
    test("update", () {
      String result = setup.runLiveStaxSync(["update"]).stdoutString;
      if (Platform.isWindows) {
        expect(result, (String x) => x.isNotEmpty);
      } else {
        expect(result, "");
      }
    });
  });
}
