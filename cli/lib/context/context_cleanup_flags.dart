import 'package:stax/context/context.dart';

extension ContextCleanupFlags on Context {
  void cleanupFlags(List<String> args) {
    bool flagTest(String arg) {
      return arg.startsWith("-");
    }

    final unknownFlags = args.where(flagTest).toList();
    args.removeWhere(flagTest);
    if (unknownFlags.isEmpty) return;
    printToConsole("Removed unknown flags: ${unknownFlags.join(", ")}");
  }
}
