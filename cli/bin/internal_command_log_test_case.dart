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

  void assignChild() {
    if (parent == null) return;
    parent?.children.add(this);
  }
}

class InternalCommandLogTestCase extends InternalCommand {
  InternalCommandLogTestCase()
      : super("log-test-case", "shows test case for log command",
            type: InternalCommandType.hidden);

  @override
  void run(List<String> args, Context context) {
    final shuffleMain = false;
    var commitsSet = [
      [_Commit(1)]
    ];
    int calculateVariants(int count) {
      if (count == 1) return 1;
      return calculateVariants(count - 1) * (count - 1);
    }

    List<_Commit> calculateCommits(int count, int index) {
      context.printToConsole("'calculateCommits $count $index");
      if (count == 1) return [_Commit(count)];
      final previous = calculateCommits(count - 1, index ~/ (count - 1));
      return [...previous, previous[index % (count - 1)].newChildCommit(count)];
    }

    void printSingleUml(
        int prefix, int index, int mainId, List<_Commit> commits) {
      String name(_Commit commit) =>
          "${prefix}_${index}_${mainId}_${commit.id}${commit.id == mainId ? "_main" : ""}";
      String nodeName(_Commit commit) => "(${name(commit)})";
      for (var commit in commits) {
        commit.children.clear();
      }
      for (var commit in commits) {
        commit.assignChild();
      }
      if (commits.length == 1) {
        context.printToConsole(nodeName(commits.first));
      } else {
        for (var commit in commits) {
          if (commit.parent == null) continue;
          context.printToConsole(
              "${nodeName(commit.parent!)} -up-> ${nodeName(commit)}");
        }
      }
      List<String> gitLines(_Commit commit) => [
            "stax commit -a --accept-all ${name(commit)}",
            ...commit.children.expand((element) => [
                  ...gitLines(element),
                  "git checkout ${name(commit)}",
                ])
          ];
      context.printToConsole("note bottom of ${nodeName(commits.first)}");
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
          .forEach((element) {
            context.printToConsole(element);
          });
      context.printToConsole("end note");
    }

    void printCalculatedCommits(int prefix, int index, int mainId) {
      printSingleUml(prefix, index, mainId, calculateCommits(prefix, index));
    }

    void printUml(int prefix) {
      for (int index = 0; index < commitsSet.length; index++) {
        for (int mainId = 1; mainId <= commitsSet[index].length; mainId++) {
          printSingleUml(prefix, index, mainId, commitsSet[index]);
          if (!shuffleMain) break;
        }
      }
    }

    List<List<_Commit>> next() {
      final id = commitsSet.first.length + 1;
      return commitsSet
          .expand((commits) => commits.mapIndexed(
              (index, element) => [...commits, element.newChildCommit(id)]))
          .toList();
    }

    context.printToConsole("@startuml");
    // printUml(1);
    printCalculatedCommits(1, 1, 1);
    commitsSet = next();
    // printUml(2);
    printCalculatedCommits(2, 1, 1);
    commitsSet = next();
    // printUml(3);
    printCalculatedCommits(3, 1, 1);
    printCalculatedCommits(3, 2, 1);
    commitsSet = next();
    // printUml(4);
    printCalculatedCommits(4, 0, 1);
    printCalculatedCommits(4, 1, 1);
    printCalculatedCommits(4, 2, 1);
    printCalculatedCommits(4, 3, 1);
    printCalculatedCommits(4, 4, 1);
    printCalculatedCommits(4, 5, 1);
    commitsSet = next();
    // printUml(5);
    context.printToConsole("@enduml");
  }
}
