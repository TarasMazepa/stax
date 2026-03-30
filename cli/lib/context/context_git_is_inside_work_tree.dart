import 'package:stax/context/context.dart';

extension ContextGitIsInsideWorkTree on Context {
  static bool? _isInsideWorkTree;

  Future<bool> isInsideWorkTree() async {
    if (_isInsideWorkTree case final isInsideWorkTree?) return isInsideWorkTree;
    return _isInsideWorkTree =
        (await quietly().git.revParseIsInsideWorkTree
                .announce('Checking if inside git work tree.')
                .run())
            .assertSuccessfulExitCode() !=
        null;
  }

  Future<bool> isNotInsideWorkTree() async {
    return !(await isInsideWorkTree());
  }

  void explainToUserNotInsideGitWorkTree() {
    printParagraph('You are not inside git work tree.');
  }

  Future<bool> handleNotInsideGitWorkingTree() async {
    if (await isInsideWorkTree()) return false;
    explainToUserNotInsideGitWorkTree();
    return true;
  }
}
