import 'package:stax/context/context.dart';

extension ContextGitAreThereStagedChanges on Context {
  bool areThereStagedChanges() {
    return git.diffCachedQuiet
            .announce('Checking if there are staged changes.')
            .runSync()
            .exitCode !=
        0;
  }

  bool areThereNoStagedChanges() {
    return !areThereStagedChanges();
  }
}
