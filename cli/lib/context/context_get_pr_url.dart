import 'package:stax/context/context.dart';

extension ContextGetPrUrl on Context {
  String? getPrUrl(String targetBranch, String currentBranch) {
    final remote = git.remote.runSync().stdout.toString().split('\n')[0].trim();
    if (remote.isEmpty) return null;

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
