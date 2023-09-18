import 'package:stax/extended_process_result.dart';

extension PrepareBranchNamesForExtraction on ExtendedProcessResult {
  Iterable<String> prepareBranchNameForExtraction() {
    return stdout.toString().split("\n").where((element) => element.length > 2);
  }
}
