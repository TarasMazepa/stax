import 'dart:io';
import 'dart:core' as core;

extension PrintForProcessResult on ProcessResult {
  void printAll() {
    core.print("ExitCode: ${this.exitCode}");
    core.print("Stdout:   ${this.stdout}".trim());
    core.print("Stderr:   ${this.stderr}".trim());
  }
}
