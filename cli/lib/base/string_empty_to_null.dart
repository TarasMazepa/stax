extension EmptyToNull on String? {
  String? emptyToNull() {
    final self = this;
    if (self == null) return null;
    if (self.isEmpty) return null;
    return self;
  }
}
