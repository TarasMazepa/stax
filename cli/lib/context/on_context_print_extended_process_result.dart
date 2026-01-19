import 'package:stax/context/context.dart';
import 'package:stax/external_command/extended_process_result.dart';

extension OnContextPrintExtendedProcessResult on Context {
  void printExtendedProcessResult(ExtendedProcessResult result) {
    if (shouldBeQuiet()) return;
    if (result.exitCode != 0) printToConsole('ExitCode: ${result.exitCode}');
    final stdout = result.stdout.toString();
    if (stdout.trim().isNotEmpty) {
      printToConsole('Stdout:\n$stdout');
    }
    final stderr = result.stderr.toString();
    if (stderr.trim().isNotEmpty) {
      printToConsole('Stderr:\n$stderr');
    }
  }
}
