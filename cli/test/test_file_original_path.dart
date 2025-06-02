String? getTestFileOriginalPath() {
  return RegExp(
    r'#.* +main.*\((.*):\d+:\d+\)',
  ).firstMatch(StackTrace.current.toString())?.group(1);
}

String assertTestFileOriginalPath() {
  return getTestFileOriginalPath()!;
}
