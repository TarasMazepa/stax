import 'package:collection/collection.dart';

class GitLogAllLine {
  final String commitHash;
  final int timestamp;
  final List<String> parentsCommitHashes;
  final List<String> parts;
  late final bool partsHasRemoteHead = parts.any(
    (x) => x.startsWith('refs/remotes/') && x.endsWith('/HEAD'),
  );
  late final bool partsHasRemoteRef = parts.any(
    (x) => x.startsWith('refs/remotes/'),
  );
  late final bool isCurrent = parts.any(
    (x) => x.startsWith('HEAD -> ') || x == 'HEAD',
  );

  String? get parentCommitHash => parentsCommitHashes.firstOrNull;

  GitLogAllLine(
    this.commitHash,
    this.timestamp,
    this.parentsCommitHashes,
    this.parts,
  );

  factory GitLogAllLine.parse(String line) {
    final parts = line.split('  ').where((x) => x.isNotEmpty).toList();
    final firstParts = parts[0].split(' ').where((x) => x.isNotEmpty).toList();

    List<String> branchParts = [];
    if (parts.length > 1) {
      String lastPart = parts.last.trim();
      if (lastPart.startsWith('(') && lastPart.endsWith(')')) {
        lastPart = lastPart.substring(1, lastPart.length - 1);
      }
      int start = 0;
      int parenDepth = 0;
      for (int i = 0; i < lastPart.length; i++) {
        if (lastPart[i] == '(') {
          parenDepth++;
        } else if (lastPart[i] == ')') {
          parenDepth--;
        } else if (lastPart[i] == ',' &&
            i + 1 < lastPart.length &&
            lastPart[i + 1] == ' ' &&
            parenDepth == 0) {
          branchParts.add(lastPart.substring(start, i).trim());
          start = i + 2;
        }
      }
      branchParts.add(lastPart.substring(start).trim());
      branchParts = branchParts
          .where((x) => x.isNotEmpty)
          .whereNot((x) => x.startsWith('tag: '))
          .toList();
    }

    return GitLogAllLine(
      firstParts.first,
      int.parse(firstParts[1]),
      firstParts.sublist(2),
      branchParts,
    );
  }

  Iterable<String> remoteBranchNames() {
    return parts
        .where((x) => x.startsWith('refs/remotes/'))
        .map((x) => x.replaceFirst('refs/remotes/', ''));
  }

  Iterable<String> localBranchNamesAndHead() {
    return parts
        .map((x) => x.replaceFirst('HEAD -> ', ''))
        .where((x) => x.startsWith('refs/heads/') || x == 'HEAD')
        .map((x) => x.replaceFirst('refs/heads/', ''));
  }

  Iterable<String> localBranchNames() {
    return localBranchNamesAndHead().whereNot((x) => x == 'HEAD');
  }

  String? branchName() {
    return localBranchNames().followedBy(remoteBranchNames()).firstOrNull;
  }

  String branchNameOrCommitHash() {
    return branchName() ?? commitHash;
  }

  @override
  String toString() {
    return "'$commitHash' '$timestamp'"
        "${parentsCommitHashes.map((x) => " '$x'").join(",")}"
        "${parts.map((x) => " '$x'").join(",")}";
  }
}
