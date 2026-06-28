import 'dart:io';

final bool isDockerAvailable = () {
  try {
    final result = Process.runSync('docker', ['info']);
    return result.exitCode == 0;
  } on ProcessException {
    return false;
  }
}();
