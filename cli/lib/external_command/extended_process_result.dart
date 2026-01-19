import 'dart:io';

import 'package:stax/context/context.dart';
import 'package:stax/context/on_context_print_extended_process_result.dart';

class ExtendedProcessResult {
  final ProcessResult _processResult;
  final Context _context;

  ExtendedProcessResult(this._processResult, this._context);

  int get exitCode => _processResult.exitCode;

  int get pid => _processResult.pid;

  get stderr => _processResult.stderr;

  get stdout => _processResult.stdout;

  ExtendedProcessResult? assertSuccessfulExitCode() {
    return isSuccess() ? this : null;
  }

  bool isSuccess() {
    return exitCode == 0;
  }

  ExtendedProcessResult printNotEmptyResultFields() {
    _context.printExtendedProcessResult(this);
    return this;
  }
}
