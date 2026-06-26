import 'dart:io';

import 'package:test/scaffolding.dart';

void main() {
  void runTest(
    String name,
    bool includeParentEnvironment,
    bool runInShell,
    ProcessStartMode mode,
  ) {
    test(name, skip: true, () async {
      final result = await Process.start('docker', [
        'run',
        '--rm',
        '-i',
        'userstmstaxcliteste2eabout_testdart',
      ]);
      result.stdout.forEach((element) {
        print('stdout:${String.fromCharCodes(element)}');
      });
      result.stderr.forEach((element) {
        print('stderr:${String.fromCharCodes(element)}');
      });
      result.exitCode.then((value) {
        print('exit code:$value');
      });
      result.stdin.writeln('echo "$name"');
      await result.stdin.flush();
      result.stdin.writeln('stax about');
      await result.stdin.flush();
      sleep(Duration(seconds: 2));
      result.kill();
    });
  }

  runTest('demo 1', false, true, ProcessStartMode.detachedWithStdio);
  runTest('demo 2', true, true, ProcessStartMode.detachedWithStdio);
  runTest('demo 3', false, false, ProcessStartMode.detachedWithStdio);
  runTest('demo 4', true, false, ProcessStartMode.detachedWithStdio);

  runTest('demo 5', false, true, ProcessStartMode.detached);
  runTest('demo 6', true, true, ProcessStartMode.detached);
  runTest('demo 7', false, false, ProcessStartMode.detached);
  runTest('demo 8', true, false, ProcessStartMode.detached);

  runTest('demo 9', false, true, ProcessStartMode.inheritStdio);
  runTest('demo 10', true, true, ProcessStartMode.inheritStdio);
  runTest('demo 11', false, false, ProcessStartMode.inheritStdio);
  runTest('demo 12', true, false, ProcessStartMode.inheritStdio);

  runTest('demo 13', false, true, ProcessStartMode.normal);
  runTest('demo 14', true, true, ProcessStartMode.normal);
  runTest('demo 15', false, false, ProcessStartMode.normal);
  runTest('demo 16', true, false, ProcessStartMode.normal);
}
