import 'package:stax/context/context.dart';

extension ContextGhCreatePr on Context {
  String? createPrWithGhCli(
    String baseBranch,
    String headBranch, {
    bool draft = false,
  }) {
    return command([
          'gh',
          'pr',
          'create',
          '--base',
          baseBranch,
          '--head',
          headBranch,
          '--fill',
          if (draft) '--draft',
        ])
        .announce('Creating PR using GitHub CLI')
        .runSyncCatching()
        ?.printNotEmptyResultFields()
        .assertSuccessfulExitCode()
        ?.stdout
        .toString()
        .trim();
  }
}
