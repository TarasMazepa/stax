import 'package:stax/context/context.dart';
import 'package:stax/on_empty_on_iterable.dart';
import 'package:stax/once.dart';

extension ContextGitGetDefaultBranch on Context {
  String? getDefaultBranch() {
    final complainAboutEmptyOnce = Once();
    return git.remote
        .announce("Checking name of your remote.")
        .runSync()
        .printNotEmptyResultFields()
        .stdout
        .toString()
        .split("\n")
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .onEmpty(complainAboutEmptyOnce.wrap(() => printToConsole(
            "You have no remotes. Can't figure out default branch.")))
        .map((remote) => (
              remote: remote,
              parts: git.revParseAbbrevRef
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
        .onEmpty(complainAboutEmptyOnce.wrap(() => printToConsole(
            "None of your remotes have '<remote>/HEAD' ref locally. Try adding one manually. Couldn't figure out default branch.")))
        .firstOrNull;
  }
}
