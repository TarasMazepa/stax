import 'package:characters/characters.dart';
import 'package:stax/branch_name/git_check_ref_format_based_sanitization.dart';

const _dash = '-';
const defaultAcceptedRegEx = r'[a-zA-Z0-9\-/\._]';

String parametrizedBranchSanitization(String input, String acceptedRegEx) {
  final accepted = RegExp(acceptedRegEx, unicode: true);
  final result = StringBuffer();
  bool wasDash = false;
  write(String string) {
    wasDash = string == _dash;
    result.write(string);
  }

  for (final character in input.characters) {
    final isForbidden = !accepted.hasMatch(character);
    switch (character) {
      case _dash when wasDash:
      case _ when isForbidden && wasDash:
        continue;
      case _ when isForbidden:
        write(_dash);
      default:
        write(character);
    }
  }
  String resultString = result.toString();
  return gitCheckRefFormatBasedSanitization(resultString);
}
