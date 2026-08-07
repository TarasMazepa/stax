import 'dart:convert';

import 'package:characters/characters.dart';
import 'package:stax/branch_name/gits_ref_name_disposition.dart';

final isUnicodeSeparatorOrControl = RegExp(r'\p{Z}|\p{Cc}', unicode: true);
const maxBranchNameLengthInBytes = 244;

String gitCheckRefFormatBasedSanitization(
  String input, {
  int maxBytes = maxBranchNameLengthInBytes,
}) {
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
      [final codeUnit] => {4, 5}.contains(
        codeUnit < gitsRefNameDisposition.length
            ? gitsRefNameDisposition[codeUnit]
            : null,
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

  String truncated = buffer.toString();
  if (utf8.encode(truncated).length > maxBytes) {
    final truncBuffer = StringBuffer();
    int currentBytes = 0;
    for (final character in truncated.characters) {
      final charBytes = utf8.encode(character).length;
      if (currentBytes + charBytes > maxBytes) {
        break;
      }
      truncBuffer.write(character);
      currentBytes += charBytes;
    }
    truncated = truncBuffer.toString();
  }

  Characters characters = truncated.characters;
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
  return result;
}
