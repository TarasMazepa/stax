import 'package:stax/context/context.dart';

extension ContextGitGetRepositoryRoot on Context {
  String? getRepositoryRoot({String? workingDirectory}) {
    return git.revParseShowTopLevel
        .announce("Getting top level location of repository.")
        .runSync(workingDirectory: workingDirectory)
        .printNotEmptyResultFields()
        .assertSuccessfulExitCode()
        ?.stdout
        .toString()
        .trim();
  }
}
