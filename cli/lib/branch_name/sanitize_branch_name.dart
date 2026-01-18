import 'package:stax/branch_name/parametrized_branch_sanitization.dart';

String sanitizeBranchName(
  String branchNameCandidate, {
  String customRegEx = defaultAcceptedRegEx,
}) {
  return parametrizedBranchSanitization(branchNameCandidate, customRegEx);
}
