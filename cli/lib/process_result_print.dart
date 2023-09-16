import 'dart:core';
import 'dart:io';

import 'package:stax/field_info.dart';

extension PrintForProcessResult on ProcessResult {
  static final _exitCodeInfo = FieldInfo(
    "ExitCode: ",
    (ProcessResult processResult) => processResult.exitCode,
    (int exitCode) => exitCode != 0,
  );
  static final _stdoutInfo = FieldInfo(
    "Stdout:\n",
    (ProcessResult processResult) => "${processResult.stdout}",
    (String stdout) => stdout.trim().isNotEmpty,
  );
  static final _stderrInfo = FieldInfo(
    "Stderr:\n",
    (ProcessResult processResult) => "${processResult.stderr}",
    (String stderr) => stderr.trim().isNotEmpty,
  );

  ProcessResult printAll() {
    _exitCodeInfo.printFieldOf(this);
    _stdoutInfo.printFieldOf(this);
    _stderrInfo.printFieldOf(this);
    return this;
  }

  ProcessResult printNotEmpty() {
    _exitCodeInfo.printFieldOfIfChecked(this);
    _stdoutInfo.printFieldOfIfChecked(this);
    _stderrInfo.printFieldOfIfChecked(this);
    return this;
  }
}
