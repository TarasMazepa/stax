import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_default_branch.dart';

import 'internal_command.dart';
import 'types_for_internal_command.dart';

class InternalCommandMainBranch extends InternalCommand {
  InternalCommandMainBranch()
      : super("main-branch", "Shows which branch stax considers to be main.",
            type: InternalCommandType.hidden);

  @override
  void run(final List<String> args, final Context context) {
    /**
     * TODO:
     *  - Add instruction on how to set default branch using git
     *  - Add ability to override default branch on per repository basis
     */
    final defaultBranch = context.getDefaultBranch();
    if (defaultBranch == null) return;
    context.printToConsole("Your default branch is '$defaultBranch'");
  }
}
