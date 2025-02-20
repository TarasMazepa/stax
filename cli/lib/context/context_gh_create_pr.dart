import 'package:stax/context/context.dart';

extension ContextGhCreatePr on Context {
  String? createPrWithGhCli(
    String title,
    String baseBranch,
    String headBranch,
  ) {
    return command([
          'gh',
          'pr',
          'create',
          '--title',
          title,
          '--base',
          baseBranch,
          '--head',
          headBranch,
          '-f',
        ])
        .announce('Creating PR using GitHub CLI')
        .runSync()
        .printNotEmptyResultFields()
        .assertSuccessfulExitCode()
        ?.stdout
        .toString()
        .trim();
  }
}
