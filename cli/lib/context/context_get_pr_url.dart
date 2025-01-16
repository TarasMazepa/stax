import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_default_remote.dart';

extension ContextGetPrUrl on Context {
  String? getPrUrl(String targetBranch, String currentBranch) {
    final remote = getDefaultRemote();
    if (remote == null) return null;
    final remoteUrl = git.remoteGetUrl
        .arg(remote)
        .runSync()
        .stdout
        .toString()
        .trim()
        .replaceFirstMapped(RegExp(r'git@(.*):'), (m) => 'https://${m[1]}/');
    if (remoteUrl.isEmpty) return null;

    return '${remoteUrl.substring(0, remoteUrl.length - 4)}/compare/$targetBranch...$currentBranch?expand=1';
  }
}
