import 'package:stax/context/context.dart';

extension ContextGhCreatePr on Context {
  Future<String?> createPrWithGhCli(
    String baseBranch,
    String headBranch, {
    bool draft = false,
  }) async {
    return (await command([
          'gh',
          'pr',
          'create',
          '--base',
          baseBranch,
          '--head',
          headBranch,
          '--fill',
          if (draft) '--draft',
        ]).announce('Creating PR using GitHub CLI').runCatching())
        ?.printNotEmptyResultFields()
        .assertSuccessfulExitCode()
        ?.stdout
        .toString()
        .trim();
  }
}
