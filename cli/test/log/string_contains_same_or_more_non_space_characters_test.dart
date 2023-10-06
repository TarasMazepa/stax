import 'package:stax/log/string_contains_same_or_more_non_space_characters.dart';
import 'package:test/test.dart';

void main() {
  test('empty', () {
    expect("".containsSameOrMoreNonSpacePositionalCharacters(""), true);
  });
  test('other bigger', () {
    expect(" ".containsSameOrMoreNonSpacePositionalCharacters("  "), false);
  });
  test('this bigger', () {
    expect("  ".containsSameOrMoreNonSpacePositionalCharacters(" "), true);
  });
  test('same spaces', () {
    expect("  ".containsSameOrMoreNonSpacePositionalCharacters("  "), true);
  });
  test('same mixed', () {
    expect(" *".containsSameOrMoreNonSpacePositionalCharacters(" *"), true);
  });
  test('mixed vs empty', () {
    expect(" *".containsSameOrMoreNonSpacePositionalCharacters("  "), true);
  });
  test('empty vs mixed', () {
    expect("  ".containsSameOrMoreNonSpacePositionalCharacters(" *"), false);
  });
  test('same full', () {
    expect("**".containsSameOrMoreNonSpacePositionalCharacters("**"), true);
  });
  test('full vs mixed', () {
    expect("**".containsSameOrMoreNonSpacePositionalCharacters(" &"), true);
  });
  test('mixed vs full', () {
    expect(" &".containsSameOrMoreNonSpacePositionalCharacters("**"), false);
  });
  test('full vs empty', () {
    expect("(*".containsSameOrMoreNonSpacePositionalCharacters("  "), true);
  });
  test('empty vs full', () {
    expect("  ".containsSameOrMoreNonSpacePositionalCharacters("(*"), false);
  });
  test('different mixed', () {
    expect(" %".containsSameOrMoreNonSpacePositionalCharacters(" *"), true);
  });
  test('different full', () {
    expect("-=".containsSameOrMoreNonSpacePositionalCharacters("_!"), true);
  });
}
