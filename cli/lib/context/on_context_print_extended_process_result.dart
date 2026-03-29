import 'package:monolib_dart/monolib_dart.dart';
import 'package:stax/context/context.dart';
import 'package:stax/external_command/extended_process_result.dart';

extension OnContextPrintExtendedProcessResult on Context {
  void printExtendedProcessResult(ExtendedProcessResult result) {
    if (shouldBeQuiet()) return;
    if (result.exitCode != 0) printToConsole('ExitCode: ${result.exitCode}');

    result.stdout.toString().trim().emptyToNull()?.let((stdout) {
      printToConsole('Stdout:\n$stdout');
    });

    result.stderr.toString().trim().emptyToNull()?.let((stderr) {
      printToConsole('Stderr:\n$stderr');
    });
  }
}
