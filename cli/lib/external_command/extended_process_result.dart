import 'dart:io';

import 'package:stax/context/context.dart';
import 'package:stax/external_command/external_command.dart';

extension ExtendedProcessResultConverter on ProcessResult {
  ExtendedProcessResult extend(ExternalCommand externalCommand) {
    return ExtendedProcessResult(this, externalCommand.context);
  }
}

class ExtendedProcessResult {
  final ProcessResult processResult;
  final Context context;

  ExtendedProcessResult(this.processResult, this.context);

  int get exitCode => processResult.exitCode;

  int get pid => processResult.pid;

  get stderr => processResult.stderr;

  get stdout => processResult.stdout;

  ExtendedProcessResult? assertSuccessfulExitCode() {
    return isSuccess() ? this : null;
  }

  bool isSuccess() {
    return exitCode == 0;
  }

  ExtendedProcessResult printNotEmptyResultFields() {
    if (exitCode != 0) context.printToConsole('ExitCode: $exitCode');
    if (stdout.toString().trim().isNotEmpty) {
      context.printToConsole('Stdout:\n$stdout');
    }
    if (stderr.toString().trim().isNotEmpty) {
      context.printToConsole('Stderr:\n$stderr');
    }
    return this;
  }
}
