import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_child_branches.dart';

import 'internal_command.dart';
import 'types_for_internal_command.dart';

class InternalCommandLog extends InternalCommand {
  InternalCommandLog()
      : super("log", "Builds a tree of all branches.",
            type: InternalCommandType.hidden);

  @override
  void run(List<String> args, Context context) {
    context.getChildBranches();
  }
}
