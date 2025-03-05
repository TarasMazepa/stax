extension NullableIndexOf on int {
  int? toNullableIndexOfResult() {
    return switch (this) {
      -1 => null,
      _ => this,
    };
  }
}
