import 'package:stax/branch_name/gits_refname_disposition.dart';
import 'package:stax/code_units.dart';
import 'package:stax/general/on_string.dart';

String gitCheckRefFormatBasedSanitization(String input) {
  StringBuffer result = StringBuffer();
  final codeUnits = input.codeUnits;
  int i = 0;
  bool wasDash = false;
  bool wasDot = false;
  bool wasSlash = false;
  bool wasAt = false;
  int dotLockIndex = 0;
  final dotLock = '.lock';
  write(int codeUnit) {
    wasDash = codeUnit == CodeUnits.dash;
    wasDot = codeUnit == CodeUnits.dot;
    wasSlash = codeUnit == CodeUnits.slash;
    wasAt = codeUnit == CodeUnits.at;
    if (dotLockIndex < dotLock.codeUnits.length &&
        codeUnit == dotLock.codeUnits[dotLockIndex]) {
      dotLockIndex++;
    } else {
      dotLockIndex = 0;
    }
    result.writeCharCode(codeUnit);
  }

  for (; i < codeUnits.length; i++) {
    final codeUnit = codeUnits[i];

    final forbidden =
        codeUnit < gitsRefnameDisposition.length &&
        {4, 5}.contains(gitsRefnameDisposition[codeUnit]);

    switch (codeUnit) {
      case _ when forbidden && (wasDash || result.isEmpty):
      case CodeUnits.dot || CodeUnits.slash || CodeUnits.dash
          when result.isEmpty:
      case CodeUnits.slash || CodeUnits.dot when wasSlash:
      case CodeUnits.leftCurlyBracket when wasAt:
      case CodeUnits.slash when dotLockIndex == 5:
      case CodeUnits.dot when wasDot:
      case CodeUnits.dash when wasDash:
        continue;
      case _ when forbidden:
        write(CodeUnits.dash);
      default:
        write(codeUnit);
    }
  }
  String resultString = result.toString();
  int right = resultString.codeUnits.length;
  while (right - 1 >= 0) {
    final codeUnit = resultString.codeUnits[right - 1];
    if (codeUnit == CodeUnits.dot ||
        codeUnit == CodeUnits.slash ||
        codeUnit == CodeUnits.dash) {
      right--;
    } else {
      break;
    }
  }
  if (right < resultString.codeUnits.length) {
    resultString = String.fromCharCodes(
      resultString.codeUnits.sublist(0, right),
    );
  }
  if (resultString.endsWith('.lock')) {
    resultString = resultString.substring(0, resultString.length - 1);
  }
  if (resultString == '@') return '';
  return resultString.enforceMaxLength(250);
}
