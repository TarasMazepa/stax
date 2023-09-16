import 'package:stax/int_range.dart';

extension CodeUnitOnInt on int {
  static final smallLetterRange =
      IntRange.closed("a".codeUnitAt(0), "z".codeUnitAt(0));
  static final largeLetterRange =
      IntRange.closed("A".codeUnitAt(0), "Z".codeUnitAt(0));
  static final numbersRange =
      IntRange.closed("0".codeUnitAt(0), "9".codeUnitAt(0));
  static final dot = ".".codeUnitAt(0);
  static final dash = "-".codeUnitAt(0);
  static final underscore = "_".codeUnitAt(0);
  static final slash = "/".codeUnitAt(0);
}
