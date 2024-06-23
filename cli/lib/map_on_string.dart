extension MapOnString on String {
  String? map(String? Function(String) map) {
    return map(this);
  }
}
