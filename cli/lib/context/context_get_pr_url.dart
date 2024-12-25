import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_remote_url.dart';

extension ContextGetPrUrl on Context {
  String? getPrUrl(String targetBranch, String currentBranch) {
    final remoteUrl = getRemoteUrl();
    if (remoteUrl == null) return null;

    return '${remoteUrl.substring(0, remoteUrl.length - 4)}/compare/$targetBranch...$currentBranch?expand=1';
  }
}
