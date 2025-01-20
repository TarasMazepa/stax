import 'package:stax/context/context.dart';

extension ContextGhCreatePr on Context {
  String? createPrWithGhCli({
    required String title,
    required String baseBranch,
    required String headBranch,
  }) {
    try {
      final result = withSilence(true)
          .command([
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
          .runSync();

      return result.exitCode == 0 ? result.stdout.toString().trim() : null;
    } catch (e) {
      return null;
    }
  }
}
