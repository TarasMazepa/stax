import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_are_there_staged_changes.dart';

extension ContextHandleAddAllFlag on Context {
  static final String addEverythingFlag = "-A";
  static final String addAllFlag = "-a";
  static final String updateAllFlag = "-u";

  static Map<String, String> get description => {
        addEverythingFlag:
            "Runs 'git add -A' before other actions. Which adds tracked and untracked files in whole working tree.",
        addAllFlag:
            "Runs 'git add .' before other actions. Which adds tracked and untracked files in current folder and subfolders.",
        updateAllFlag:
            "Runs 'git add -u' before other actions. Which adds only tracked files in whole working tree.",
      };

  void handleAddAllFlag(List<String> args) {
    final hasAddEverything = args.remove(addEverythingFlag);
    final hasAddAll = args.remove(addAllFlag);
    final hasUpdateAll = args.remove(updateAllFlag);
    if (hasAddEverything || hasAddAll || hasUpdateAll) {
      final selectedAddAll = hasAddEverything
          ? git.addEverything
          : (hasAddAll ? git.addAll : git.addUpdate);
      if (areThereStagedChanges()) {
        selectedAddAll
            .askContinueQuestion(
                "You already have some staged changes. Do you really want to proceed?")
            ?.announce("Adding changes, as per your request.")
            .runSync()
            .printNotEmptyResultFields();
      } else {
        selectedAddAll
            .announce("Adding changes, as per your request.")
            .runSync()
            .printNotEmptyResultFields();
      }
    } else {
      if (areThereNoStagedChanges()) {
        git.addEverything
            .askContinueQuestion(
                "You do not have any staged changes. Do you want to add all?")
            ?.announce("Adding all the changes, as per your request.")
            .runSync()
            .printNotEmptyResultFields();
      }
    }
  }
}
