import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_are_there_staged_changes.dart';

extension ContextHandleAddAllFlag on Context {
  static final String addAllFlag = "-a";
  static final String updateAllFlag = "-u";

  static Map<String, String> get description => {
        addAllFlag:
            "Runs 'git add .' before other actions. Which adds tracked and untracked files.",
        updateAllFlag:
            "Runs 'git add -u .' before other actions. Which adds only tracked files.",
      };

  void handleAddAllFlag(List<String> args) {
    final hasAddAll = args.remove(addAllFlag);
    final hasUpdateAll = args.remove(updateAllFlag);
    if (hasAddAll || hasUpdateAll) {
      final selectedAddAll = hasAddAll ? git.addAll : git.addUpdate;
      if (areThereStagedChanges()) {
        selectedAddAll
            .askContinueQuestion(
                "You already have some staged changes. Do you really want to add all?")
            ?.announce("Adding all the changes, as per your request.")
            .runSync()
            .printNotEmptyResultFields();
      } else {
        selectedAddAll
            .announce("Adding all the changes, as per your request.")
            .runSync()
            .printNotEmptyResultFields();
      }
    } else {
      if (areThereNoStagedChanges()) {
        git.addAll
            .askContinueQuestion(
                "You do not have any staged changes. Do you want to add all?")
            ?.announce("Adding all the changes, as per your request.")
            .runSync()
            .printNotEmptyResultFields();
      }
    }
  }
}
