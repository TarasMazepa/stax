import 'package:stax/branch_name/git_check_ref_format_based_sanitization.dart';
import 'package:stax/code_units.dart';
import 'package:stax/int_range.dart';

extension ContainsOnListOfIntRanges on List<IntRange> {
  bool anyRangeContains(int number) {
    return any((element) => element.contains(number));
  }
}

bool isLetter(int codeUnit) {
  return [
    CodeUnits.smallLetterRange,
    CodeUnits.largeLetterRange,
    CodeUnits.underscoreRange,
  ].anyRangeContains(codeUnit);
}

bool isLetterOrNumber(int codeUnit) {
  return [
    CodeUnits.smallLetterRange,
    CodeUnits.largeLetterRange,
    CodeUnits.underscoreRange,
    CodeUnits.numbersRange,
  ].anyRangeContains(codeUnit);
}

bool isAcceptableSpecialSymbol(int codeUnit) {
  return [
    CodeUnits.dashRange,
    CodeUnits.dotRange,
    CodeUnits.slashRange,
  ].anyRangeContains(codeUnit);
}

String sanitizeBranchName(String branchNameCandidate) {
  final substituteCharacter = String.fromCharCode(CodeUnits.dash);

  bool wasSpecialSymbol = false;
  StringBuffer buffer = StringBuffer();
  for (var codeUnit in branchNameCandidate.codeUnits) {
    if (wasSpecialSymbol) {
      if (isLetterOrNumber(codeUnit)) {
        buffer.writeCharCode(codeUnit);
        wasSpecialSymbol = false;
      } else {
        // skip as we do not want to have special symbols one after another one
      }
    } else {
      if (isLetterOrNumber(codeUnit)) {
        buffer.writeCharCode(codeUnit);
      } else {
        if (isAcceptableSpecialSymbol(codeUnit)) {
          buffer.writeCharCode(codeUnit);
        } else {
          buffer.write(substituteCharacter);
        }
        wasSpecialSymbol = true;
      }
    }
  }
  String result = buffer.toString();
  int left = 0;
  int right = result.codeUnits.length;
  bool moved = false;
  while (left < right - 1) {
    if (isLetter(result.codeUnitAt(left))) break;
    left++;
    moved = true;
  }
  while (left < right - 1) {
    if (isLetterOrNumber(result.codeUnitAt(right - 1))) break;
    right--;
    moved = true;
  }
  if (moved) {
    result = String.fromCharCodes(result.codeUnits, left, right);
  }
  return gitCheckRefFormatBasedSanitization(result);
}
