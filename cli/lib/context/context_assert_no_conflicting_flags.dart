import 'package:stax/command/flag.dart';
import 'package:stax/context/context.dart';

extension ContextAssertNoConflictingFlags on Context {
  bool assertNoConflictingFlags(List<Flag> flags) {
    final result = flags.length > 1;
    if (result) {
      printParagraph("""You have used conflicting flags:
${flags.map((e) => "  $e").join("\n")}""");
    }
    return result;
  }
}
