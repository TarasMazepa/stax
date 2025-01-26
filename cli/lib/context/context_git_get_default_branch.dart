import 'package:stax/context/context.dart';
import 'package:stax/map_on_string.dart';
import 'package:stax/on_empty_on_iterable.dart';
import 'package:stax/once.dart';

extension ContextGitGetDefaultBranch on Context {
  static List<String>? remotes;
  static String? defaultBranch;

  String? getDefaultBranch() {
    final override = settings.defaultBranch.value;
    if (override.isNotEmpty) return override;

    if (defaultBranch != null) return defaultBranch;
    final complainAboutEmptyOnce = Once();
    remotes = git.remote
        .announce('Checking name of your remote.')
        .runSync()
        .printNotEmptyResultFields()
        .stdout
        .toString()
        .split('\n')
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .onEmpty(
          complainAboutEmptyOnce.wrap(
            () => printToConsole(
              "You have no remotes. Can't figure out default branch.",
            ),
          ),
        )
        .toList();
    return defaultBranch = remotes
        ?.map(
          (remote) => (
            remote: remote,
            parts: git.revParseAbbrevRef
                .arg('$remote/HEAD')
                .announce("Checking default branch on '$remote' remote.")
                .runSync()
                .printNotEmptyResultFields()
                .stdout
                .toString()
                .trim()
                .split('/')
          ),
        )
        .where((e) => e.parts.length == 2)
        .where((e) => e.remote == e.parts[0])
        .map((e) => e.parts[1])
        .onEmpty(
          complainAboutEmptyOnce.wrap(
            () => printToConsole(
              "None of your remotes have '<remote>/HEAD' ref locally. Try adding one manually. Couldn't figure out default branch.",
            ),
          ),
        )
        .firstOrNull
        ?.map((x) => x == 'HEAD' ? null : x);
  }
}
