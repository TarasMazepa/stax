import 'package:stax/context/context.dart';

extension ContextGitLogOneLineNoDecorateSingleBranch on Context {
  List<CommitHashAndMessage> logOneLineNoDecorateSingleBranch(String branch) {
    return git.logOneLineNoDecorate
        .arg(branch)
        .runSync()
        .stdout
        .toString()
        .split("\n")
        .map((x) => x.trim())
        .where((x) => x.isNotEmpty)
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
      line.substring(0, splitPoint),
      line.substring(splitPoint + 1),
    );
  }
}
