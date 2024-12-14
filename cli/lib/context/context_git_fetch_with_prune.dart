import 'package:stax/context/context.dart';

extension ContentGitFetchWithPrune on Context {
  void fetchWithPrune() {
    git.fetchWithPrune
        .announce('Fetching latest changes from remote.')
        .runSync()
        .printNotEmptyResultFields();
  }
}
