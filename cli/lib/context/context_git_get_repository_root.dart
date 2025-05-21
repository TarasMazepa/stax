import 'package:stax/context/context.dart';

extension ContextGitGetRepositoryRoot on Context {
  static String? _repositoryRoot;
  static bool _loadedRepositoryRoot = false;

  String? getRepositoryRoot() {
    if (_loadedRepositoryRoot) return _repositoryRoot;
    _loadedRepositoryRoot = true;
    return _repositoryRoot = git.revParseShowTopLevel
        .announce('Getting top level location of repository.')
        .runSync()
        .printNotEmptyResultFields()
        .assertSuccessfulExitCode()
        ?.stdout
        .toString()
        .trim();
  }
}
