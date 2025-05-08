import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_default_remote.dart';

extension ContextGetPullRequestUrl on Context {
  String? getPullRequestUrl(String baseBranch, String currentBranch) {
    final remote = getPreferredRemote();
    if (remote == null) return null;
    final remoteUrl = git.remoteGetUrl
        .arg(remote)
        .runSync()
        .stdout
        .toString()
        .trim()
        .replaceFirstMapped(RegExp(r'git@(.*):'), (m) => 'https://${m[1]}/');
    if (remoteUrl.isEmpty) return null;

    return '${remoteUrl.substring(0, remoteUrl.length - 4)}/compare/$baseBranch...$currentBranch?expand=1';
  }
}
