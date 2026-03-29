import 'package:monolib_dart/monolib_dart.dart';
import 'package:stax/context/context.dart';
import 'package:stax/external_command/extended_process_result.dart';

extension OnContextPrintExtendedProcessResult on Context {
  void printExtendedProcessResult(ExtendedProcessResult result) {
    if (shouldBeQuiet()) return;
    if (result.exitCode != 0) printToConsole('ExitCode: ${result.exitCode}');

    if (result.stdout.toString().trim().emptyToNull() case final stdout?) {
      printToConsole('Stdout:\n$stdout');
    }

    if (result.stderr.toString().trim().emptyToNull() case final stderr?) {
      printToConsole('Stderr:\n$stderr');
    }
  }
}
