import 'package:stax/context/context.dart';

extension ContextGitAreThereStagedChanges on Context {
  bool isThereStagedChanges() {
    return git.diffCachedQuiet
            .announce("Checking if there staged changes.")
            .runSync()
            .exitCode !=
        0;
  }

  bool isThereNoStagedChanges() {
    return !isThereStagedChanges();
  }
}
