extension StringCleanCarriageReturnOnWindows on String {
  String cleanCarriageReturnOnWindows() {
    return replaceAll('\r\n', '\n');
  }
}
