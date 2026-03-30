import 'package:stax/context/context.dart';

extension ContextGitAreThereStagedChanges on Context {
  Future<bool> areThereStagedChanges() async {
    return (await git.diffCachedQuiet
                .announce('Checking if there are staged changes.')
                .run())
            .exitCode !=
        0;
  }

  Future<bool> areThereNoStagedChanges() async {
    return !(await areThereStagedChanges());
  }
}
