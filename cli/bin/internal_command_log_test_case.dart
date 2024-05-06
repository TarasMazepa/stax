import 'dart:math';

import 'package:collection/collection.dart';
import 'package:stax/context/context.dart';
import 'package:stax/log/decorated/decorated_log_line_producer.dart';

import 'internal_command.dart';
import 'types_for_internal_command.dart';

class _CommitTree implements DecoratedLogLineProducerAdapter<int> {
  static final _alphabet =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
  static const initialCommitId = 0;

  final List<int> indexes;
  final int mainId;
  final int currentId;
  late String compacted = indexes.map((e) => _alphabet[e]).join();

  _CommitTree(this.indexes, this.mainId, this.currentId);

  int get length => indexes.length;

  _CommitTree next() {
    if (isTimeToLengthen()) {
      return lengthenAndReset();
    }
    if (currentId != length) {
      return _CommitTree(indexes, mainId, currentId + 1);
    }
    if (mainId != length) {
      return _CommitTree(indexes, mainId + 1, 0);
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
    return _CommitTree(newIndexes, 0, 0);
  }

  bool isTimeToLengthen() {
    if (currentId != length) return false;
    if (mainId != length) return false;
    for (int i = 0; i < length; i++) {
      if (indexes[i] != i) return false;
    }
    return true;
  }

  _CommitTree lengthenAndReset() {
    return _CommitTree(List.filled(length + 1, 0), 0, 0);
  }

  _CommitTree subIndexes(int end) {
    if (end < 0) return this;
    final biggestId = end + 1;
    int newId(int currentId) {
      while (currentId >= biggestId) {
        currentId = indexes[currentId - 1];
      }
      return currentId;
    }

    return _CommitTree(
      indexes.sublist(0, end),
      newId(mainId),
      newId(currentId),
    );
  }

  List<_CommitTree> allSubIndexes() {
    final result = <_CommitTree>[];
    for (int i = 0; i <= length; i++) {
      result.add(subIndexes(i));
    }
    return result;
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
    return _CommitTree(indexes, mainId, currentId);
  }

  factory _CommitTree.random(int length, [int? mainId, int? currentId]) {
    final random = Random();
    final indexes = <int>[];
    for (int i = 0; i < length; i++) {
      indexes.add(random.nextInt(i + 1));
    }
    return _CommitTree(indexes, mainId ?? random.nextInt(length),
        currentId ?? random.nextInt(length));
  }

  String toUmlString() {
    String result = "";
    void addToResult(String string) {
      result += "$string\n";
    }

    String nodeName(int id) => "(${commitName(id)})";
    if (length == 0) {
      addToResult(nodeName(initialCommitId));
    } else {
      indexes.forEachIndexed((index, element) {
        addToResult("${nodeName(element)} -up-> ${nodeName(index + 1)}");
      });
    }
    addToResult("note bottom of ${nodeName(initialCommitId)}");
    getTargetCommands().forEach(addToResult);
    getTargetOutput().forEach((element) => addToResult("\"\"$element\"\""));
    addToResult("end note");
    return result.trim();
  }

  List<String> getTargetCommands() {
    String previousValue = "";
    bool haveSeenNonCheckout = false;
    List<String> gitLines(int id) => [
          "stax commit -a --accept-all ${commitName(id)}",
          ..._children(id).expand((element) => element == id
              ? [
                  ...gitLines(element),
                  "git checkout ${commitName(id)}",
                ]
              : [])
        ];

    return gitLines(initialCommitId)
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
        .followedBy(["git checkout ${commitName(currentId)}"])
        .toList();
  }

  List<String> getTargetOutput() {
    return materializeDecoratedLogLines(initialCommitId, this);
  }

  @override
  String toString() {
    return "mainId:$mainId currentId:$currentId indexes:$indexes compacted:$compacted";
  }

  String commitName(int commitId) {
    return "${compacted}_${mainId}_${currentId}_$commitId";
  }

  @override
  String branchName(int id) {
    final rawName = commitName(id);
    final name = " $rawName ";
    if (isDefaultBranch(id)) {
      return name;
    }
    if (isDefaultBranchOrHasDefaultBranchAsAChild(id)) {
      return "[$rawName]";
    }
    return name;
  }

  bool isDefaultBranchOrHasDefaultBranchAsAChild(int id) {
    return isDefaultBranch(id) ||
        _children(id).any(
            (element) => isDefaultBranchOrHasDefaultBranchAsAChild(element));
  }

  int sortingValue(int id) {
    return isDefaultBranchOrHasDefaultBranchAsAChild(id) ? 10000 : id;
  }

  int collapsedChild(int id) {
    if (isCurrent(id)) return id;
    if (isDefaultBranch(id)) return id;
    if (_children(id).length != 1) return id;
    if (!isDefaultBranchOrHasDefaultBranchAsAChild(id)) return id;
    return collapsedChild(_children(id).single);
  }

  List<int> _children(int id) {
    return indexes
        .expandIndexed<int>(
            (index, element) => element == id ? [index + 1] : [])
        .toList();
  }

  @override
  List<int> children(int id) {
    return _children(id)
        .map(collapsedChild)
        .sorted((a, b) => sortingValue(b) - sortingValue(a));
  }

  @override
  bool isDefaultBranch(int id) {
    return id == mainId;
  }

  @override
  bool isCurrent(int id) {
    return id == currentId;
  }
}

class _Commit {
  final _Commit? parent;
  final int id;
  final List<_Commit> children = [];

  _Commit(this.id, [this.parent]);

  _Commit newChildCommit(int id) => _Commit(id, this);

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
