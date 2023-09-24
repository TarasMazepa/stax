import 'package:stax/context/context.dart';

extension ContextGitGetRepositoryRoot on Context {
  String? getRepositoryRoot() {
    return git.revParseShowTopLevel
        .announce("Getting top level location of repository.")
        .runSync()
        .printNotEmptyResultFields()
        .assertSuccessfulExitCode()
        ?.stdout
        .toString()
        .trim();
  }
}
