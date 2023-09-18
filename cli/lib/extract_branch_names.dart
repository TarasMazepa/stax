import 'package:stax/nullable_index_of.dart';

extension ExtractBranchNamesFromLines on Iterable<String> {
  Iterable<String> extractBranchNames() {
    return map(
        (e) => e.substring(2, e.indexOf(" ", 2).toNullableIndexOfResult()));
  }
}
