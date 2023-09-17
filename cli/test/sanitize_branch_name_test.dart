import 'package:stax/count_on_list.dart';
import 'package:test/test.dart';

import '../bin/sanitize_branch_name.dart';

void main() {
  test('no changes needed', () {
    expect(sanitizeBranchName("perfectly-n0rmal.branch_name/maybe"),
        "perfectly-n0rmal.branch_name/maybe");
  });
  test('removing left trailing symbols', () {
    expect(sanitizeBranchName("14287890241_...--//---b"), "b");
  });
  test('removing right trailing symbols', () {
    expect(sanitizeBranchName("b1_...#^%^*&(*)*(--//---"), "b1");
  });
  test('removing left and right trailing symbols', () {
    expect(sanitizeBranchName("14287890241_...--//---b_...#^%^*&(*)*(--//---"),
        "b");
  });
  test('substituting with dash', () {
    expect(sanitizeBranchName("almost good name"), "almost-good-name");
  });
  test('substituting with underscore', () {
    expect(sanitizeBranchName("almost good_name"), "almost_good_name");
  });
  test('removing subsequent symbols', () {
    expect(
        sanitizeBranchName(
            "remove-----------me________please//////I......ask****you"),
        "remove-me_please/I.ask-you");
  });
}
