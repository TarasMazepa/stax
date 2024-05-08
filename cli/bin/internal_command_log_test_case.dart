import 'package:stax/commit_tree_for_test_cases.dart';
import 'package:stax/context/context.dart';

import 'internal_command.dart';
import 'types_for_internal_command.dart';

class InternalCommandLogTestCase extends InternalCommand {
  InternalCommandLogTestCase()
      : super("log-test-case", "shows test case for log command",
            type: InternalCommandType.hidden);

  @override
  void run(List<String> args, Context context) {
    context.printToConsole("@startuml");
    var indexes = CommitTreeForTestCases();
    for (int i = 0; i <= 20; i++) {
      context.printToConsole(indexes.toUmlString());
      indexes = indexes.next();
    }
    context.printToConsole("@enduml");
  }
}
