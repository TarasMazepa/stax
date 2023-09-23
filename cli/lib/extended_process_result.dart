import 'dart:io';

import 'package:stax/context/context.dart';
import 'package:stax/external_command.dart';

import 'field_info.dart';

extension ExtendedProcessResultCoverter on ProcessResult {
  ExtendedProcessResult extend(ExternalCommand externalCommand) {
    return ExtendedProcessResult(this, externalCommand.context);
  }
}

class ExtendedProcessResult {
  static final _exitCodeInfo = FieldInfo(
    "ExitCode: ",
    (ExtendedProcessResult processResult) => processResult.exitCode,
    (int exitCode) => exitCode != 0,
  );
  static final _stdoutInfo = FieldInfo(
    "Stdout:\n",
    (ExtendedProcessResult processResult) => "${processResult.stdout}",
    (String stdout) => stdout.trim().isNotEmpty,
  );
  static final _stderrInfo = FieldInfo(
    "Stderr:\n",
    (ExtendedProcessResult processResult) => "${processResult.stderr}",
    (String stderr) => stderr.trim().isNotEmpty,
  );

  final ProcessResult processResult;
  final Context context;

  ExtendedProcessResult(this.processResult, this.context);

  int get exitCode => processResult.exitCode;

  int get pid => processResult.pid;

  get stderr => processResult.stderr;

  get stdout => processResult.stdout;

  ExtendedProcessResult? assertSuccessfulExitCode() {
    return exitCode == 0 ? this : null;
  }

  ExtendedProcessResult printAllResultFields() {
    if (context.silent) return this;
    _exitCodeInfo.printFieldOf(this);
    _stdoutInfo.printFieldOf(this);
    _stderrInfo.printFieldOf(this);
    return this;
  }

  ExtendedProcessResult printNotEmptyResultFields() {
    if (context.silent) return this;
    _exitCodeInfo.printFieldOfIfChecked(this);
    _stdoutInfo.printFieldOfIfChecked(this);
    _stderrInfo.printFieldOfIfChecked(this);
    return this;
  }
}
