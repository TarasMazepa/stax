import 'package:stax/context/context.dart';

extension ContextGhCreatePr on Context {
  String? createPrWithGhCli(
    String title,
    String baseBranch,
    String headBranch,
  ) {
    final replacedBaseBranch = getReplacedBaseBranch(baseBranch);

    return command([
      'gh',
      'pr',
      'create',
      '--title',
      title,
      '--base',
      replacedBaseBranch,
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

  String getReplacedBaseBranch(String baseBranch) {
    final replacement = settings.baseBranchReplacement.getValue(baseBranch);
    if (replacement != null) {
      printToConsole(
        'Replacing base branch "$baseBranch" with "$replacement" as configured in settings',
      );
      return replacement;
    }
    return baseBranch;
  }
}
