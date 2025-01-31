class Pair<K, V> {
  final K key;
  final V value;

  const Pair(this.key, this.value);

  static Pair<String, String> parseString(String input) {
    final parts = input.split(':');
    if (parts.length != 2) {
      throw FormatException('Invalid pair format. Expected "key:value"');
    }
    return Pair(parts[0], parts[1]);
  }

  @override
  String toString() => '$key:$value';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pair && other.key == key && other.value == value;
  }

  @override
  int get hashCode => Object.hash(key, value);
}
