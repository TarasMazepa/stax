import 'package:stax/context/context.dart';

extension ContextGitLogOneLineNoDecorateSingleBranch on Context {
  List<CommitHashAndMessage> logOneLineNoDecorateSingleBranch(String branch) {
    return git.logOneLineNoDecorate
        .arg(branch)
        .runSync()
        .stdout
        .toString()
        .trim()
        .split("\n")
        .map(CommitHashAndMessage.parse)
        .toList();
  }
}

class CommitHashAndMessage {
  final String hash;
  final String message;

  CommitHashAndMessage(this.hash, this.message);

  factory CommitHashAndMessage.parse(String line) {
    final splitPoint = line.indexOf(" ");
    return CommitHashAndMessage(
        line.substring(0, splitPoint), line.substring(splitPoint + 1));
  }
}
