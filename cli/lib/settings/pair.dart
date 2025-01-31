class Pair<T1, T2> {
  final T1 first;
  final T2 second;

  const Pair(this.first, this.second);

  @override
  String toString() => '$first:$second';

  static Pair<String, String> parseString(String input) {
    final parts = input.split(':');
    if (parts.length != 2) {
      throw FormatException(
        'Invalid pair format. Expected "key:value", got "$input"',
      );
    }
    return Pair(parts[0], parts[1]);
  }
}
