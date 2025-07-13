import 'package:collection/collection.dart';

class GitLogAllLine {
  final String commitHash;
  final int timestamp;
  final String? parentCommitHash;
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

  GitLogAllLine(
      this.commitHash,
      this.timestamp,
      this.parentCommitHash,
      this.parts,
      );

  factory GitLogAllLine.parse(String line) {
    final parts = line.split('  ').where((x) => x.isNotEmpty).toList();
    final firstParts = parts[0].split(' ').where((x) => x.isNotEmpty).toList();
    return GitLogAllLine(
      firstParts.first,
      int.parse(firstParts[1]),
      firstParts.elementAtOrNull(2),
      parts.length > 1
          ? parts.last
          .replaceAll('(', '')
          .replaceAll(')', '')
          .split(', ')
          .map((x) => x.trim())
          .where((x) => x.isNotEmpty)
          .whereNot((x) => x.startsWith('tag: '))
          .toList()
          : [],
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
        "${parentCommitHash == null ? "" : " '$parentCommitHash'"}"
        "${parts.isEmpty ? "" : " ${parts.map((x) => "'$x'").join(" ")}"}";
  }
}
