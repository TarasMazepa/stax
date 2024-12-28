import 'package:stax/context/context.dart';

extension ContextGitGetRemoteUrl on Context {
  String? getRemoteUrl() {
    final remote = git.remote.runSync().stdout.toString().trim();
    if (remote.isEmpty) return null;

    final remoteUrl = git.remoteGetUrl
        .arg(remote)
        .runSync()
        .stdout
        .toString()
        .trim()
        .replaceFirstMapped(RegExp(r'git@(.*):'), (m) => 'https://${m[1]}/');

    return remoteUrl.isEmpty ? null : remoteUrl;
  }
}
