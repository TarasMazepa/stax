import 'dart:math';

import 'package:collection/collection.dart';
import 'package:stax/context/context.dart';
import 'package:stax/log/decorated/decorated_log_line_producer.dart';

import 'internal_command.dart';
import 'types_for_internal_command.dart';

class _DecoratedLogLineProducerAdapterForLogTestCase
    implements DecoratedLogLineProducerAdapter<_Commit> {
  final _CommitTree commitTree;
  final int mainId;

  _DecoratedLogLineProducerAdapterForLogTestCase(this.commitTree, this.mainId);

  @override
  String branchName(_Commit t) {
    return t.name(commitTree, mainId);
  }

  @override
  List<_Commit> children(_Commit t) {
    return t.children.sorted((a, b) => b.id - a.id);
  }

  @override
  bool isDefaultBranch(_Commit t) {
    return t.id == mainId;
  }
}

class _Commit {
  final _Commit? parent;
  final int id;
  final List<_Commit> children = [];

  _Commit(this.id, [this.parent]);

  _Commit newChildCommit(int id) => _Commit(id, this);

  String name(_CommitTree commitTree, int mainId) {
    return "${commitTree.commitNamePrefix}_${mainId}_$id${id == mainId ? "_main" : ""}";
  }

  void assignChild() {
    if (parent == null) return;
    parent?.children.add(this);
  }
}

class _CommitTree {
  final List<_Commit> commits;
  final String code;

  int get size => commits.length;

  String get commitNamePrefix => "${size}_$code";

  _CommitTree(this.code, this.commits);

  _CommitTree.initial() : this("0", [_Commit(0)]);

  _CommitTree next(int index, String code) {
    return _CommitTree(
        code, [...commits, commits[index % size].newChildCommit(size)]);
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
      return [_CommitTree.initial()];
    }
    final previous = chain(size - 1, index ~/ (size - 1));
    return [previous.first.next(index, index.toString()), ...previous];
  }

  static List<_CommitTree> indexedChain(List<int> indexes) {
    final result = [_CommitTree.initial()];
    for (final index in indexes) {
      result.add(result.last.next(index, index.toString()));
    }
    return result;
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
    materializeDecoratedLogLines(commits.first,
            _DecoratedLogLineProducerAdapterForLogTestCase(this, mainId))
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
    for (var commitTree in _CommitTree.randomChain(14)) {
      context.printToConsole(
          commitTree.toUmlString(Random().nextInt(commitTree.size)));
    }
    context.printToConsole("@enduml");
  }
}
