import 'package:characters/characters.dart';
import 'package:stax/branch_name/gits_ref_name_disposition.dart';
import 'package:stax/general/on_object.dart';
import 'package:stax/general/on_string.dart';

final isUnicodeSeparatorOrControl = RegExp(r'\p{Z}|\p{Cc}', unicode: true);

String gitCheckRefFormatBasedSanitization(String input) {
  final buffer = StringBuffer();
  bool wasDash = false;
  bool wasDot = false;
  bool wasSlash = false;
  bool wasAt = false;
  int dotLockIndex = 0;
  final dotLockString = '.lock';
  void write(String codeUnit) {
    wasDash = codeUnit == '-';
    wasDot = codeUnit == '.';
    wasSlash = codeUnit == '/';
    wasAt = codeUnit == '@';
    if (dotLockIndex < dotLockString.length &&
        codeUnit == dotLockString[dotLockIndex]) {
      dotLockIndex++;
    } else {
      dotLockIndex = 0;
    }
    buffer.write(codeUnit);
  }

  for (final character in input.characters) {
    late final forbidden = switch (character.codeUnits) {
      [final codeUnit] => gitsRefNameDisposition.elementAtOrNull(codeUnit).isIn(
        {4, 5},
      ),
      _ => isUnicodeSeparatorOrControl.hasMatch(character),
    };

    switch (character) {
      case '.' || '/' || '-' when buffer.isEmpty:
      case '/' || '.' when wasSlash:
      case '{' when wasAt:
      case '/' when dotLockIndex == 5:
      case '.' when wasDot:
      case '-' when wasDash:
      case _ when forbidden && (wasDash || buffer.isEmpty):
        continue;
      case _ when forbidden:
        write('-');
      default:
        write(character);
    }
  }
  Characters characters = buffer.toString().characters;
  CharacterRange iterator = characters.iteratorAtEnd;
  whileLoop:
  while (iterator.moveBack()) {
    switch (iterator.current) {
      case '.' || '/' || '-':
        continue;
      default:
        iterator.moveNext();
        break whileLoop;
    }
  }
  String result = iterator.stringBefore;
  if (result.endsWith('.lock')) {
    result = result.substring(0, result.length - 1);
  }
  if (result == '@') return '';
  return result.enforceMaxLength(250);
}
