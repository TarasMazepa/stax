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
  ].anyRangeContains(codeUnit);
}

bool isLetterOrNumber(int codeUnit) {
  return [
    CodeUnits.smallLetterRange,
    CodeUnits.largeLetterRange,
    CodeUnits.numbersRange,
  ].anyRangeContains(codeUnit);
}

bool isAcceptableSpecialSymbol(int codeUnit) {
  return [
    CodeUnits.dashRange,
    CodeUnits.dotRange,
    CodeUnits.underscoreRange,
    CodeUnits.slashRange,
  ].anyRangeContains(codeUnit);
}

String sanitizeBranchName(String branchNameCandidate) {
  final substituteCharacter = String.fromCharCode(CodeUnits.dash);

  bool wasSpecialSymbol = false;
  String result = "";
  for (var codeUnit in branchNameCandidate.codeUnits) {
    if (wasSpecialSymbol) {
      if (isLetterOrNumber(codeUnit)) {
        result += String.fromCharCode(codeUnit);
        wasSpecialSymbol = false;
      } else {
        // skip as we do not want to have special symbols one after another one
      }
    } else {
      if (isLetterOrNumber(codeUnit)) {
        result += String.fromCharCode(codeUnit);
      } else {
        if (isAcceptableSpecialSymbol(codeUnit)) {
          result += String.fromCharCode(codeUnit);
        } else {
          result += substituteCharacter;
        }
        wasSpecialSymbol = true;
      }
    }
  }
  int left = 0;
  int right = result.length;
  while (left < right) {
    if (isLetter(result.codeUnitAt(left))) break;
    left++;
  }
  while (left < right) {
    if (isLetterOrNumber(result.codeUnitAt(right - 1))) break;
    right--;
  }
  return String.fromCharCodes(result.codeUnits, left, right);
}
