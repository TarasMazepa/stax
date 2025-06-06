String? getTestFileUriString() {
  return RegExp(
    r'#.* +main.*\((.*):\d+:\d+\)',
  ).firstMatch(StackTrace.current.toString())?.group(1);
}

String assertTestFileUriString() {
  return getTestFileUriString()!;
}

String? getTestFilePath() {
  final uriString = getTestFileUriString();
  if (uriString == null) return null;
  return Uri.tryParse(uriString)?.toFilePath();
}

String assertTestFilePath() {
  return getTestFilePath()!;
}
