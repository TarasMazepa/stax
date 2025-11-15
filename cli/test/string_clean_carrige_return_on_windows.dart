import 'dart:io';

extension StringCleanCarriageReturnOnWindows on String {
  String cleanCarriageReturnOnWindows() {
    if (!Platform.isWindows) return this;
    return replaceAll('\r\n', '\n');
  }
}
