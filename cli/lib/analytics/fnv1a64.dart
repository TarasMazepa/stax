int fnv1a64(String input) {
  const int fnvOffsetBasis = 0xcbf29ce484222325;
  const int fnvPrime = 0x100000001b3;
  int hash = fnvOffsetBasis;

  for (final codeUnit in input.codeUnits) {
    hash ^= codeUnit;
    hash = (hash * fnvPrime) & 0xFFFFFFFFFFFFFFFF;
  }
  return hash;
}

String fnv1a64String(String input) {
  return fnv1a64(input).abs().toRadixString(16).padLeft(16, '0');
}
