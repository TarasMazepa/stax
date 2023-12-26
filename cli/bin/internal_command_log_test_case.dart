import 'dart:math';

import 'package:collection/collection.dart';
import 'package:stax/context/context.dart';
import 'package:stax/log/decorated/decorated_log_line_producer.dart';

import 'internal_command.dart';
import 'types_for_internal_command.dart';

class _CompactedIndexes {
  static final _alphabet =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

  final List<int> indexes;
  final String compacted;
  final List<_Commit> commits;
  final int mainId;

  _CompactedIndexes(this.indexes, this.compacted, this.commits, this.mainId);

  int get length => indexes.length;

  _CompactedIndexes next() {
    if (mainId != commits.length - 1) {
      return _CompactedIndexes(indexes, compacted, commits, mainId + 1);
    }
    final newIndexes = [...indexes];
    for (int i = newIndexes.length - 1; i >= 0; i--) {
      if (newIndexes[i] != i) {
        newIndexes[i]++;
        break;
      } else {
        newIndexes[i] = 0;
      }
    }
    return _CompactedIndexes.fromIndexes(newIndexes, 0);
  }

  bool isTimeToLengthen() {
    if (mainId != commits.length - 1) return false;
    for (int i = 0; i < length; i++) {
      if (indexes[i] != i) return false;
    }
    return true;
  }

  _CompactedIndexes lengthenAndReset() {
    return _CompactedIndexes.fromIndexes(List.filled(length + 1, 0), 0);
  }

  _CompactedIndexes subIndexes(int end) {
    if (end < 0) return this;
    final biggestId = end + 1;
    int newMainId = mainId;
    while (newMainId >= biggestId) {
      newMainId = commits[newMainId].parent!.id;
    }
    return _CompactedIndexes(
      indexes.sublist(0, end),
      compacted.substring(0, end),
      commits.sublist(0, biggestId),
      newMainId,
    );
  }

  List<_CompactedIndexes> allSubIndexes() {
    final result = <_CompactedIndexes>[];
    for (int i = 0; i <= length; i++) {
      result.add(subIndexes(i));
    }
    return result;
  }

  factory _CompactedIndexes.calculateCommits(
    List<int> indexes,
    String compacted,
    int mainId,
  ) {
    int id = 0;
    final commits = [_Commit(id++)];
    for (int index in indexes) {
      commits.add(commits[index].newChildCommit(id++));
    }
    return _CompactedIndexes(indexes, compacted, commits, mainId);
  }

  factory _CompactedIndexes.fromIndexes(List<int> indexes, int mainId) {
    final compacted = StringBuffer();
    for (int i = 0; i < indexes.length; i++) {
      final index = indexes[i];
      if (i < index) throw Exception("indexes[$i] $index > $i");
      compacted.write(_alphabet[index]);
    }
    return _CompactedIndexes.calculateCommits(
        indexes, compacted.toString(), mainId);
  }

  factory _CompactedIndexes.fromCompacted(String compactedWithMainId) {
    final indexes = <int>[];
    final parts = compactedWithMainId.split("_");
    final compacted = parts.first;
    final mainId = int.tryParse(parts.last) ?? 0;
    for (int i = 0; i < compacted.length; i++) {
      final char = compacted[i];
      final index = _alphabet.indexOf(char);
      if (index == -1) {
        throw Exception("'$char' is not in base64 alphabet '$_alphabet'");
      }
      indexes.add(index);
    }
    return _CompactedIndexes.calculateCommits(indexes, compacted, mainId);
  }

  factory _CompactedIndexes.random(int length, [int? mainId]) {
    final random = Random();
    final indexes = <int>[];
    for (int i = 0; i < length; i++) {
      indexes.add(random.nextInt(i + 1));
    }
    return _CompactedIndexes.fromIndexes(
        indexes, mainId ?? random.nextInt(length));
  }

  @override
  String toString() {
    return "indexes:$indexes compacted:$compacted commits:$commits";
  }
}

class _DecoratedLogLineProducerAdapterForLogTestCase
    implements DecoratedLogLineProducerAdapter<_Commit> {
  final _CommitTree commitTree;
  final bool showBranchedCommitNames;

  _DecoratedLogLineProducerAdapterForLogTestCase(
      this.commitTree, this.showBranchedCommitNames);

  @override
  String branchName(_Commit commit) {
    final rawName = commit.name(commitTree);
    final name = showBranchedCommitNames ? " $rawName " : rawName;
    if (isDefaultBranch(commit)) {
      return name;
    }
    if (isDefaultBranchOrHasDefaultBranchAsAChild(commit)) {
      if (showBranchedCommitNames) {
        return "[$rawName]";
      } else {
        return "";
      }
    }
    return name;
  }

  bool isDefaultBranchOrHasDefaultBranchAsAChild(_Commit commit) {
    return isDefaultBranch(commit) ||
        commit.children.any(
            (element) => isDefaultBranchOrHasDefaultBranchAsAChild(element));
  }

  int sortingValue(_Commit commit) {
    return isDefaultBranchOrHasDefaultBranchAsAChild(commit)
        ? 10000
        : commit.id;
  }

  _Commit collapsedChild(_Commit commit) {
    if (isDefaultBranch(commit)) return commit;
    if (commit.children.length != 1) return commit;
    if (!isDefaultBranchOrHasDefaultBranchAsAChild(commit)) return commit;
    return collapsedChild(commit.children.single);
  }

  @override
  List<_Commit> children(_Commit commit) {
    return commit.children
        .map(collapsedChild)
        .sorted((a, b) => sortingValue(b) - sortingValue(a));
  }

  @override
  bool isDefaultBranch(_Commit commit) {
    return commit.id == commitTree.indexes.mainId;
  }
}

class _Commit {
  final _Commit? parent;
  final int id;
  final List<_Commit> children = [];

  _Commit(this.id, [this.parent]);

  _Commit newChildCommit(int id) => _Commit(id, this);

  String name(_CommitTree commitTree) {
    return "${commitTree.indexes.compacted}_${commitTree.indexes.mainId}_$id${id == commitTree.indexes.mainId ? "_main" : ""}";
  }

  void assignChild() {
    if (parent == null) return;
    parent?.children.add(this);
  }

  @override
  String toString() {
    return "$id <- ${parent?.id}";
  }
}

class _CommitTree {
  final _CompactedIndexes indexes;

  List<_Commit> get commits => indexes.commits;

  _CommitTree(this.indexes);

  static List<_CommitTree> indexedChain(_CompactedIndexes indexes) {
    return indexes.allSubIndexes().map(_CommitTree.new).toList();
  }

  String toUmlString() {
    String result = "";
    void addToResult(String string) {
      result += "$string\n";
    }

    String name(_Commit commit) => commit.name(this);
    String nodeName(_Commit commit) => "(${name(commit)})";
    for (var commit in commits) {
      commit.children.clear();
    }
    for (var commit in commits) {
      commit.assignChild();
    }
    if (commits.length == 1) {
      addToResult(nodeName(commits.first));
    } else {
      for (var commit in commits) {
        if (commit.parent == null) continue;
        addToResult("${nodeName(commit.parent!)} -up-> ${nodeName(commit)}");
      }
    }
    List<String> gitLines(_Commit commit) => [
          "stax commit -a --accept-all ${name(commit)}",
          ...commit.children.expand((element) => [
                ...gitLines(element),
                "git checkout ${name(commit)}",
              ])
        ];
    addToResult("note bottom of ${nodeName(commits.first)}");
    String previousValue = "";
    bool haveSeenNonCheckout = false;
    gitLines(commits.first)
        .reversed
        .whereIndexed((index, element) {
          if (haveSeenNonCheckout) return true;
          if (!element.startsWith("git checkout")) {
            return haveSeenNonCheckout = true;
          }
          return false;
        })
        .where((element) {
          final result = !(previousValue.startsWith("git checkout") &&
              element.startsWith("git checkout"));
          previousValue = element;
          return result;
        })
        .toList()
        .reversed
        .forEach(addToResult);
    final adapter = _DecoratedLogLineProducerAdapterForLogTestCase(this, false);
    materializeDecoratedLogLines(adapter.collapsedChild(commits.first), adapter)
        .forEach((element) => addToResult("\"\"$element\"\""));
    addToResult("end note");
    return result.trim();
  }
}

class InternalCommandLogTestCase extends InternalCommand {
  InternalCommandLogTestCase()
      : super("log-test-case", "shows test case for log command",
            type: InternalCommandType.hidden);

  @override
  void run(List<String> args, Context context) {
    context.printToConsole("@startuml");
    var indexes = _CompactedIndexes.fromCompacted("ABCBDFDFGCKJFFDIHKOQ_8");
    for (int i = 0; i <= 20; i++) {
      context.printToConsole(_CommitTree(indexes).toUmlString());
      indexes = indexes.subIndexes(indexes.length - 1);
    }
    context.printToConsole("@enduml");
  }
}
