import 'package:stax/command/flag.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_are_there_staged_changes.dart';

extension ContextHandleAddAllFlag on Context {
  static final Flag addEverythingFlag = Flag(
    short: "-A",
    description:
        "Runs 'git add -A' before other actions. Which adds tracked and untracked files in whole working tree.",
  );
  static final Flag addAllFlag = Flag(
    short: "-a",
    description:
        "Runs 'git add .' before other actions. Which adds tracked and untracked files in current folder and subfolders.",
  );
  static final Flag updateAllFlag = Flag(
    short: "-u",
    description:
        "Runs 'git add -u' before other actions. Which adds only tracked files in whole working tree.",
  );

  static final List<Flag> flags = [
    addEverythingFlag,
    addAllFlag,
    updateAllFlag,
  ];

  void handleAddAllFlag(List<String> args) {
    final hasAddEverything = addEverythingFlag.hasFlag(args);
    final hasAddAll = addAllFlag.hasFlag(args);
    final hasUpdateAll = updateAllFlag.hasFlag(args);
    if (hasAddEverything || hasAddAll || hasUpdateAll) {
      final selectedAddAll = hasAddEverything
          ? git.addEverything
          : (hasAddAll ? git.addAll : git.addUpdate);
      if (areThereStagedChanges()) {
        selectedAddAll
            .askContinueQuestion(
              "You already have some staged changes. Do you really want to proceed?",
            )
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
              "You do not have any staged changes. Do you want to add all?",
            )
            ?.announce("Adding all the changes, as per your request.")
            .runSync()
            .printNotEmptyResultFields();
      }
    }
  }
}
