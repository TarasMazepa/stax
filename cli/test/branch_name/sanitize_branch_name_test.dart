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
    expect(sanitizeBranchName('14287890241...--//---b'), '14287890241.-/-b');
  });
  test('removing right trailing symbols', () {
    expect(sanitizeBranchName('b1...#^%^*&(*)*(--//---'), 'b1');
  });
  test('removing left and right trailing symbols', () {
    expect(
      sanitizeBranchName('14287890241...--//---b...#^%^*&(*)*(--//---'),
      '14287890241.-/-b',
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
  test(
    'long commit message converted to branch name fits GitHub 255 byte ref limit',
    () {
      final commitMessage =
          'Add CSV parsing error reporting to models and relocate StreamWithOnCompleteCallback. Add logger error reporting to fromCsv in IdNameAndDescription, IdAndWeight, and ItemCriteriaScore. Move StreamWithOnCompleteCallback from lib/tracer to lib/stream. Add logger error reporting to fromCsv in IdNameAndDescription, IdAndWeight, and ItemCriteriaScore';
      final branchName = sanitizeBranchName(commitMessage);
      final ref = 'refs/heads/$branchName';
      expect(branchName.length, lessThanOrEqualTo(244));
      expect(ref.length, lessThanOrEqualTo(255));
      expect(
        branchName,
        'Add-CSV-parsing-error-reporting-to-models-and-relocate-StreamWithOnCompleteCallback.-Add-logger-error-reporting-to-fromCsv-in-IdNameAndDescription-IdAndWeight-and-ItemCriteriaScore.-Move-StreamWithOnCompleteCallback-from-lib/tracer-to-lib/strea',
      );
    },
  );
}
