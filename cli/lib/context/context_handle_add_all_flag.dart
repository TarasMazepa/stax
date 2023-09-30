import 'package:stax/context/context.dart';

extension ContextHandleAddAllFlag on Context {
  static Map<String, String> get description => {
        "-a": "Runs 'git add .' before other actions.",
      };

  void handleAddAllFlag(List<String> args) {
    if (!args.remove("-a")) return;
    git.addAll
        .announce("Adding all the changes, as per your request.")
        .runSync()
        .printNotEmptyResultFields();
  }
}
