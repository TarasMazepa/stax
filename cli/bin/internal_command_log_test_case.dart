import 'dart:math';

import 'package:collection/collection.dart';
import 'package:stax/context/context.dart';
import 'package:stax/log/decorated/decorated_log_line_producer.dart';

import 'internal_command.dart';
import 'types_for_internal_command.dart';

class _CommitTree implements DecoratedLogLineProducerAdapter<_Commit> {
  static final _alphabet =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

  final List<int> indexes;
  final String compacted;
  final List<_Commit> commits;
  final int mainId;
  final int currentId;

  _CommitTree(
      this.indexes, this.compacted, this.commits, this.mainId, this.currentId);

  int get length => indexes.length;

  _CommitTree next() {
    if (isTimeToLengthen()) {
      return lengthenAndReset();
    }
    if (currentId != commits.length - 1) {
      return _CommitTree(indexes, compacted, commits, mainId, currentId + 1);
    }
    if (mainId != commits.length - 1) {
      return _CommitTree(indexes, compacted, commits, mainId + 1, 0);
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
    return _CommitTree.fromIndexes(newIndexes, 0, 0);
  }

  bool isTimeToLengthen() {
    if (currentId != commits.length - 1) return false;
    if (mainId != commits.length - 1) return false;
    for (int i = 0; i < length; i++) {
      if (indexes[i] != i) return false;
    }
    return true;
  }

  _CommitTree lengthenAndReset() {
    return _CommitTree.fromIndexes(List.filled(length + 1, 0), 0, 0);
  }

  _CommitTree subIndexes(int end) {
    if (end < 0) return this;
    final biggestId = end + 1;
    int newMainId = mainId;
    while (newMainId >= biggestId) {
      newMainId = commits[newMainId].parent!.id;
    }
    int newCurrentId = currentId;
    while (newCurrentId >= biggestId) {
      newCurrentId = commits[newCurrentId].parent!.id;
    }
    return _CommitTree(
      indexes.sublist(0, end),
      compacted.substring(0, end),
      commits.sublist(0, biggestId),
      newMainId,
      newCurrentId,
    );
  }

  List<_CommitTree> allSubIndexes() {
    final result = <_CommitTree>[];
    for (int i = 0; i <= length; i++) {
      result.add(subIndexes(i));
    }
    return result;
  }

  factory _CommitTree.calculateCommits(
    List<int> indexes,
    String compacted,
    int mainId,
    int currentId,
  ) {
    int id = 0;
    final commits = [_Commit(id++)];
    for (int index in indexes) {
      commits.add(commits[index].newChildCommit(id++));
    }
    return _CommitTree(indexes, compacted, commits, mainId, currentId);
  }

  factory _CommitTree.fromIndexes(
    List<int> indexes,
    int mainId,
    int currentId,
  ) {
    final compacted = StringBuffer();
    for (int i = 0; i < indexes.length; i++) {
      final index = indexes[i];
      if (i < index) throw Exception("indexes[$i] $index > $i");
      compacted.write(_alphabet[index]);
    }
    return _CommitTree.calculateCommits(
        indexes, compacted.toString(), mainId, currentId);
  }

  factory _CommitTree.fromCompacted(String compactedWithMainAndCurrentIds) {
    final indexes = <int>[];
    final parts = compactedWithMainAndCurrentIds.split("_");
    final compacted = parts.first;
    for (int i = 0; i < compacted.length; i++) {
      final char = compacted[i];
      final index = _alphabet.indexOf(char);
      if (index == -1) {
        throw Exception("'$char' is not in base64 alphabet '$_alphabet'");
      }
      indexes.add(index);
    }
    final mainId = int.tryParse(parts.elementAtOrNull(1) ?? "") ?? 0;
    final currentId = int.tryParse(parts.elementAtOrNull(2) ?? "") ?? 0;
    return _CommitTree.calculateCommits(indexes, compacted, mainId, currentId);
  }

  factory _CommitTree.random(int length, [int? mainId, int? currentId]) {
    final random = Random();
    final indexes = <int>[];
    for (int i = 0; i < length; i++) {
      indexes.add(random.nextInt(i + 1));
    }
    return _CommitTree.fromIndexes(indexes, mainId ?? random.nextInt(length),
        currentId ?? random.nextInt(length));
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
    addToResult("git checkout ${name(commits[currentId])}");
    materializeDecoratedLogLines(collapsedChild(commits.first), this)
        .forEach((element) => addToResult("\"\"$element\"\""));
    addToResult("end note");
    return result.trim();
  }

  @override
  String toString() {
    return "mainId:$mainId currentId:$currentId indexes:$indexes compacted:$compacted commits:$commits";
  }

  @override
  String branchName(_Commit commit) {
    final rawName = commit.name(this);
    final name = " $rawName ";
    if (isDefaultBranch(commit)) {
      return name;
    }
    if (isDefaultBranchOrHasDefaultBranchAsAChild(commit)) {
      return "[$rawName]";
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
    if (isCurrent(commit)) return commit;
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
    return commit.id == mainId;
  }

  @override
  bool isCurrent(_Commit commit) {
    return commit.id == currentId;
  }
}

class _Commit {
  final _Commit? parent;
  final int id;
  final List<_Commit> children = [];

  _Commit(this.id, [this.parent]);

  _Commit newChildCommit(int id) => _Commit(id, this);

  String name(_CommitTree indexes) {
    return "${indexes.compacted}_${indexes.mainId}_${indexes.currentId}_$id";
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

class InternalCommandLogTestCase extends InternalCommand {
  InternalCommandLogTestCase()
      : super("log-test-case", "shows test case for log command",
            type: InternalCommandType.hidden);

  @override
  void run(List<String> args, Context context) {
    context.printToConsole("@startuml");
    var indexes = _CommitTree.fromCompacted("");
    for (int i = 0; i <= 20; i++) {
      context.printToConsole(indexes.toUmlString());
      indexes = indexes.next();
    }
    context.printToConsole("@enduml");
  }
}
