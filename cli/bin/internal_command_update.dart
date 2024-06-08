import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_current_branch.dart';

import 'internal_command.dart';

class InternalCommandUpdate extends InternalCommand {
  InternalCommandUpdate() : super("update", "Updates to the latest version.");

  @override
  void run(final List<String> args, Context context) {
    context = context
        .withScriptPathAsWorkingDirectory()
        .withRepositoryRootAsWorkingDirectory();
    final currentBranch = context.getCurrentBranch();
    final mainBranch = "main";
    if (currentBranch != mainBranch) {
      final result = context.git.checkout
          .arg(mainBranch)
          .askContinueQuestion(
              "Switching from '$currentBranch' to '$mainBranch' branch.")
          ?.announce("Switching to '$mainBranch'.")
          .runSync()
          .printNotEmptyResultFields();
      if (result == null) return;
    }
    context.git.pull
        .announce("Pulling new changes.")
        .runSync()
        .printNotEmptyResultFields();
    context.printToConsole(
        "Please refer to the most recent installation instructions in the repository README file for accurate and up-to-date information. You can find the installation section here: https://github.com/TarasMazepa/homebrew-stax");
  }
}
