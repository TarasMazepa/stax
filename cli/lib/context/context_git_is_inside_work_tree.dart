import 'package:stax/context/context.dart';

extension ContextGitIsInsideWorkTree on Context {
  static bool? _isInsideWorkTree;

  bool isInsideWorkTree() {
    if (_isInsideWorkTree != null) return _isInsideWorkTree!;
    return _isInsideWorkTree = withQuiet(true).git.revParseIsInsideWorkTree
            .announce('Checking if inside git work tree.')
            .runSync()
            .assertSuccessfulExitCode() !=
        null;
  }

  bool isNotInsideWorkTree() {
    return !isInsideWorkTree();
  }

  void explainToUserNotInsideGitWorkTree() {
    printParagraph('You are not inside git work tree.');
  }

  bool handleNotInsideGitWorkingTree() {
    if (isInsideWorkTree()) return false;
    explainToUserNotInsideGitWorkTree();
    return true;
  }
}
