import 'package:stax/external_command/extended_process_result.dart';
import 'package:stax/nullable_index_of.dart';

extension ParseBranchInfoOnExtendedProcessResult on ExtendedProcessResult {
  List<BranchInfo> parseBranchInfo() {
    return stdout
        .toString()
        .split('\n')
        .where((e) => e.isNotEmpty)
        .map(BranchInfo.parse)
        .where((e) => e.isValid())
        .toList();
  }
}

class BranchInfo {
  final String raw;
  final bool current;
  final String name;
  final String commitHash;
  final String commitMessage;
  final bool gone;
  final int? ahead;
  final int? behind;
  final String? remote;

  BranchInfo(
    this.raw,
    this.current,
    this.name,
    this.commitHash,
    this.commitMessage,
    this.gone,
    this.ahead,
    this.behind,
    this.remote,
  );

  bool isValid() {
    return commitHash.length >= 5;
  }

  factory BranchInfo.parse(String raw) {
    final current = raw[0] == '*';
    final nameStartIndex = 2;
    int? nameEndIndex;
    int i;
    for (i = 3; i < raw.length; i++) {
      if (raw[i] == ' ') {
        nameEndIndex = i;
        break;
      }
    }
    final name = raw.substring(nameStartIndex, nameEndIndex);
    while (raw[i] == ' ') {
      i++;
    }
    final commitHashStartIndex = i;
    int? commitHashEndIndex;
    for (; i < raw.length; i++) {
      if (raw[i] == ' ') {
        commitHashEndIndex = i;
        break;
      }
    }
    while (raw[i] == ' ') {
      i++;
    }
    final afterCommitHashSpaces = i;
    int commitMessageStarIndex = i;
    bool gone = false;
    int? ahead;
    int? behind;
    String? remote;
    if (raw[i] == '[') {
      i++;
      final clothingBracketIndex = raw
          .indexOf(']', i)
          .toNullableIndexOfResult();
      if (clothingBracketIndex != null) {
        commitMessageStarIndex = clothingBracketIndex + 2;
        final remoteInfo = raw.substring(i, clothingBracketIndex).split(':');
        if (remoteInfo.length > 1) {
          remote = remoteInfo[0];
          final remoteMarkers = remoteInfo[1]
              .split(',')
              .map((e) => e.trim())
              .toList();
          gone = remoteMarkers.contains('gone');
          parsePrefixed(String prefix) => remoteMarkers
              .where((e) => e.startsWith(prefix))
              .map((e) => e.split(' '))
              .where((e) => e.length == 2)
              .map((e) => int.tryParse(e[1]))
              .firstOrNull;
          ahead = parsePrefixed('ahead ');
          behind = parsePrefixed('behind ');
        }
      } else {
        commitMessageStarIndex = afterCommitHashSpaces;
      }
    }
    return BranchInfo(
      raw,
      current,
      name,
      raw.substring(commitHashStartIndex, commitHashEndIndex),
      raw.substring(commitMessageStarIndex),
      gone,
      ahead,
      behind,
      remote,
    );
  }

  @override
  String toString() {
    return "$name ${current ? "current " : ""}$commitHash${remote != null ? " $remote" : ""}${gone ? " gone" : ""}${ahead != null ? " $ahead ahead" : ""}${behind != null ? " $behind behind" : ""} $commitMessage";
  }
}
