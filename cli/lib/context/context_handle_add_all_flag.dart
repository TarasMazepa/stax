import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_are_there_staged_changes.dart';

extension ContextHandleAddAllFlag on Context {
  static Map<String, String> get description => {
        "-a": "Runs 'git add .' before other actions.",
      };

  void handleAddAllFlag(List<String> args) {
    if (args.remove("-a")) {
      if (areThereStagedChanges()) {
        git.addAll
            .askContinueQuestion(
                "You already have some staged changes. Do you really want to add all?")
            ?.announce("Adding all the changes, as per your request.")
            .runSync()
            .printNotEmptyResultFields();
      } else {
        git.addAll
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
