import 'package:stax/command/flag.dart';
import 'package:stax/context/context.dart';

extension ContextAssertNoConflictingFlags on Context {
  bool assertNoConflictingFlags(List<bool> values, List<Flag> flags) {
    List<Flag> selected = [];
    for (int i = 0; i < values.length; i++) {
      if (values[i]) {
        selected.add(flags[i]);
      }
    }
    final result = selected.length > 1;
    if (result) {
      printParagraph("""You have used conflicting flags:
${selected.map((e) => "  $e").join("\n")}
""");
    }
    return result;
  }
}
