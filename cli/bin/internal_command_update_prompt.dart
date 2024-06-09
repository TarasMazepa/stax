import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_fetch_with_prune.dart';
import 'package:stax/context/context_git_is_current_branch_ahead_or_behind.dart';
import 'package:stax/settings/settings.dart';

import 'internal_command.dart';
import 'types_for_internal_command.dart';

class InternalCommandUpdatePrompt extends InternalCommand {
  InternalCommandUpdatePrompt()
      : super("update-prompt", "Asks about updating.",
            type: InternalCommandType.hidden);

  bool shouldAutoUpdateAfterExecutingCommand(
      final List<String> args, Context context) {
    final lastUpdatePrompt = Settings.instance.lastUpdatePrompt.get();
    final now = DateTime.now();
    final silenceDuration = Duration(days: 7);
    if (lastUpdatePrompt.add(silenceDuration).isAfter(now)) return false;
    Settings.instance.lastUpdatePrompt.set(now);
    context = context
        .withScriptPathAsWorkingDirectory()
        .withRepositoryRootAsWorkingDirectory();
    if (!context.isCurrentBranchBehind()) {
      context.fetchWithPrune();
      if (!context.isCurrentBranchBehind()) {
        return false;
      }
    }

    return false;
  }

  @override
  void run(final List<String> args, Context context) {
    shouldAutoUpdateAfterExecutingCommand(args, context);
  }
}
