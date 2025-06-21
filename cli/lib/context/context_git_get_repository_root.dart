import 'package:stax/context/context.dart';
import 'package:stax/map_on_string.dart';

extension ContextGitGetRepositoryRoot on Context {
  static String? _repositoryRoot;
  static bool _loadedRepositoryRoot = false;

  String? getRepositoryRoot() {
    if (_loadedRepositoryRoot) return _repositoryRoot;
    _loadedRepositoryRoot = true;
    return _repositoryRoot = git.revParseAbsoluteGitDir
        .announce('Getting top level location of repository.')
        .runSync()
        .printNotEmptyResultFields()
        .assertSuccessfulExitCode()
        ?.stdout
        .toString()
        .trim()
        .map((string) => string.substring(0, string.indexOf('.git') - 1));
  }
}
