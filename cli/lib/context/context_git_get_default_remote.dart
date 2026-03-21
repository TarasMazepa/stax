import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_default_remote_and_branch.dart';

extension ContextGitGetPreferredRemote on Context {
  String? getPreferredRemote() {
    return getDefaultRemoteAndBranch()?.remote;
  }
}
