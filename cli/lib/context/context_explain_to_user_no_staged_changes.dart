import 'package:stax/context/context.dart';

extension ContextExplainToUserNoStagedChanges on Context {
  void explainToUserNoStagedChanges() {
    printParagraph("Can't commit - there is nothing staged. "
        "You can add -a flag next time to add all the files. "
        "Or run 'git add .' to add all the changes. "
        "Or add individual files using 'git add <filename>'. "
        "For more information see 'git add --help'. "
        "If that haven't worked - try editing some files.");
  }
}
