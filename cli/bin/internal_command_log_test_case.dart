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

  _CompactedIndexes(this.indexes, this.compacted, this.commits);

  int get length => indexes.length;

  _CompactedIndexes subIndexes(int end) {
    return _CompactedIndexes(
      indexes.sublist(0, end),
      compacted.substring(0, end),
      commits.sublist(0, end),
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
      List<int> indexes, String compacted) {
    int id = 0;
    final commits = [_Commit(id++)];
    for (int index in indexes) {
      commits.add(commits[index].newChildCommit(id++));
    }
    return _CompactedIndexes(indexes, compacted, commits);
  }

  factory _CompactedIndexes.fromIndexes(List<int> indexes) {
    final compacted = StringBuffer();
    for (int i = 0; i < indexes.length; i++) {
      final index = indexes[i];
      if (i < index) throw Exception("indexes[$i] $index > $i");
      compacted.write(_alphabet[index]);
    }
    return _CompactedIndexes.calculateCommits(indexes, compacted.toString());
  }

  factory _CompactedIndexes.fromCompacted(String compacted) {
    final indexes = <int>[];
    for (int i = 0; i < compacted.length; i++) {
      final char = compacted[i];
      final index = _alphabet.indexOf(char);
      if (index == -1) {
        throw Exception("'$char' is not in base64 alphabet '$_alphabet'");
      }
      indexes.add(index);
    }
    return _CompactedIndexes.calculateCommits(indexes, compacted);
  }

  factory _CompactedIndexes.random(int length) {
    final random = Random();
    final indexes = <int>[];
    for (int i = 0; i < length; i++) {
      indexes.add(random.nextInt(i + 1));
    }
    return _CompactedIndexes.fromIndexes(indexes);
  }

  @override
  String toString() {
    return "indexes:$indexes compacted:$compacted commits:$commits";
  }
}

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

  @override
  String toString() {
    return "$id <- ${parent?.id}";
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

  static List<_CommitTree> indexedChain(_CompactedIndexes indexes) {
    final result = [_CommitTree.initial()];
    for (final index in indexes.indexes) {
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
    context.printToConsole("'${_CompactedIndexes.random(10)}");
    for (var commitTree
        in _CommitTree.indexedChain(_CompactedIndexes.random(14))) {
      context.printToConsole(commitTree.toUmlString(0));
    }
    context.printToConsole("@enduml");
  }
}
