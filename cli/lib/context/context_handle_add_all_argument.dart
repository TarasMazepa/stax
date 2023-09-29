import 'package:stax/context/context.dart';

extension ContextHandleAddAllArgument on Context {
  void handleAddAllArgument(List<String> args) {
    if (!args.remove("-a")) return;
    git.addAll
        .announce("Adding all the changes, as per your request.")
        .runSync()
        .printNotEmptyResultFields();
  }
}
