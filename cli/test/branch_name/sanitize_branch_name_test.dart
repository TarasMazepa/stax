import 'package:stax/branch_name/sanitize_branch_name.dart';
import 'package:test/test.dart';

void main() {
  test('no changes needed', () {
    expect(
      sanitizeBranchName('perfectly-n0rmal.branch_name/maybe'),
      'perfectly-n0rmal.branch_name/maybe',
    );
  });
  test('removing left trailing symbols', () {
    expect(sanitizeBranchName('14287890241...--//---b'), 'b');
  });
  test('removing right trailing symbols', () {
    expect(sanitizeBranchName('b1...#^%^*&(*)*(--//---'), 'b1');
  });
  test('removing left and right trailing symbols', () {
    expect(
      sanitizeBranchName('14287890241...--//---b...#^%^*&(*)*(--//---'),
      'b',
    );
  });
  test('substituting with dash', () {
    expect(sanitizeBranchName('almost good name'), 'almost-good-name');
  });
  test('substituting with underscore', () {
    expect(sanitizeBranchName('almost good_name'), 'almost-good_name');
  });
  test('removing subsequent symbols', () {
    expect(
      sanitizeBranchName('remove-----------me_please//////I......ask****you'),
      'remove-me_please/I.ask-you',
    );
  });
  test('_0_0_0', () {
    expect(sanitizeBranchName('_0_0_0'), '_0_0_0');
  });
}
