import 'package:stax/context/context.dart';
import 'package:monolib_dart/monolib_dart.dart';

extension ContextGitGetRepositoryRoot on Context {
  static String? _repositoryRoot;
  static bool _loadedRepositoryRoot = false;

  Future<String?> getRepositoryRoot() async {
    if (_loadedRepositoryRoot) return _repositoryRoot;
    _loadedRepositoryRoot = true;
    return _repositoryRoot =
        (await git.revParseAbsoluteGitDir
                .announce('Getting top level location of repository.')
                .run())
            .printNotEmptyResultFields()
            .assertSuccessfulExitCode()
            ?.stdout
            .toString()
            .trim()
            .let((string) => string.substring(0, string.indexOf('.git') - 1));
  }
}
