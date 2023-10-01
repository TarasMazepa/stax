import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_all_branches.dart';

import 'internal_command.dart';

class InternalCommandLog extends InternalCommand {
  InternalCommandLog() : super("log", "Builds a tree of all branches.");

  @override
  void run(List<String> args, Context context) {
    context.printToConsole(context.getAllBranches().join("\n"));
  }
}
