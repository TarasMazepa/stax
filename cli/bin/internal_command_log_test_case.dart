import 'dart:math';

import 'package:collection/collection.dart';
import 'package:stax/context/context.dart';

import 'internal_command.dart';
import 'types_for_internal_command.dart';

class _Commit {
  final _Commit? parent;
  final int id;
  final List<_Commit> children = List.empty(growable: true);

  _Commit(this.id, [this.parent]);

  _Commit newChildCommit(int id) => _Commit(id, this);

  String name(_CommitTree commitTree, int mainId) {
    return "${commitTree.size}_${commitTree.index}_${mainId}_$id${id == mainId ? "_main" : ""}";
  }

  void assignChild() {
    if (parent == null) return;
    parent?.children.add(this);
  }
}

class _CommitTree {
  final int size;
  final int index;
  final List<_Commit> commits;

  _CommitTree(this.size, this.index, this.commits);

  _CommitTree next(int index) {
    final size = this.size + 1;
    return _CommitTree(size, index,
        [...commits, commits[index % (size - 1)].newChildCommit(size)]);
  }

  factory _CommitTree.generate(int size, int index) {
    return chain(size, index).first;
  }

  static int variants(int size) {
    if (size == 1) return 1;
    return min(4294967296, variants(size - 1) * (size - 1));
  }

  static List<_CommitTree> randomChain(int size) {
    return chain(size, Random().nextInt(variants(size)));
  }

  static List<_CommitTree> chain(int size, int index) {
    if (size == 1) {
      return [
        _CommitTree(1, 0, [_Commit(1)])
      ];
    }
    final previous = chain(size - 1, index ~/ (size - 1));
    return [previous.first.next(index), ...previous];
  }

  String toUmlString(int mainId) {
    String result = "";
    void addToResult(String string) {
      result += "$string\n";
    }

    String name(_Commit commit) => commit.name(this, mainId);
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
    for (var commitTree in _CommitTree.randomChain(17)) {
      context.printToConsole(commitTree.toUmlString(1));
    }
    context.printToConsole("@enduml");
  }
}
