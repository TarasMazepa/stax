import 'package:stax/context/context.dart';

extension ContextGitIsInsideWorkTree on Context {
  bool isInsideWorkTree() {
    return withSilence(true)
            .git
            .revParseIsInsideWorkTree
            .announce("Checking if inside git work tree.")
            .runSync()
            .assertSuccessfulExitCode() !=
        null;
  }

  bool isNotInsideWorkTree() {
    return !isInsideWorkTree();
  }

  void explainToUserNotInsideGitWorkTree() {
    printParagraph("You are not inside git working tree.");
  }

  bool handleNotInsideGitWorkingTree() {
    if (isInsideWorkTree()) return false;
    explainToUserNotInsideGitWorkTree();
    return true;
  }
}
