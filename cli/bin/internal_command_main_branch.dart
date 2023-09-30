import 'package:stax/context/context.dart';
import 'package:stax/on_empty_on_iterable.dart';
import 'package:stax/once.dart';

import 'internal_command.dart';
import 'types_for_internal_command.dart';

class InternalCommandMainBranch extends InternalCommand {
  InternalCommandMainBranch()
      : super("main-branch", "Shows which branch stax considers to be main.",
            type: InternalCommandType.hidden);

  String? getDefaultBranch(final List<String> args, final Context context) {
    final emptyComplain = Once();
    return context.git.remote
        .announce("Checking name of your remote.")
        .runSync()
        .printNotEmptyResultFields()
        .stdout
        .toString()
        .split("\n")
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .onEmpty(emptyComplain.wrap(() => context.printToConsole(
            "You have no remotes. Can't figure out default branch.")))
        .map((remote) => (
              remote: remote,
              parts: context.git.revParseAbbrevRef
                  .arg("$remote/HEAD")
                  .announce("Checking default branch on '$remote' remote.")
                  .runSync()
                  .printNotEmptyResultFields()
                  .stdout
                  .toString()
                  .trim()
                  .split("/")
            ))
        .where((e) => e.parts.length == 2)
        .where((e) => e.remote == e.parts[0])
        .map((e) => e.parts[1])
        .onEmpty(emptyComplain.wrap(() => context.printToConsole(
            "None of your remotes have '<remote>/HEAD' ref locally. Try adding one manually. Couldn't figure out default branch.")))
        .firstOrNull;
  }

  @override
  void run(final List<String> args, final Context context) {
    final defaultBranch = getDefaultBranch(args, context);
    if (defaultBranch == null) return;
    context.printToConsole("Your default branch is '$defaultBranch'");
  }
}
