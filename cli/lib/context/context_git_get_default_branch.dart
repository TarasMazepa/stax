import 'package:stax/context/context.dart';
import 'package:monolib_dart/monolib_dart.dart';

extension ContextGitGetDefaultBranch on Context {
  static List<String>? remotes;
  static String? defaultBranch;

  String? getConfiguredDefaultBranch() {
    final override = effectiveSettings.defaultBranch.value;
    if (override.isNotEmpty) return override;
    return null;
  }

  Future<String?> getDefaultBranch() async {
    final configured = getConfiguredDefaultBranch();
    if (configured != null) return configured;

    if (defaultBranch != null) return defaultBranch;
    final complainAboutEmptyOnce = Once();
    remotes = (await git.remote.announce('Checking name of your remote.').run())
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

    if (remotes == null) return null;

    List<({String remote, List<String> parts})> results = [];
    for (final remote in remotes!) {
      final result =
          (await git.revParseAbbrevRef
                  .arg('$remote/HEAD')
                  .announce("Checking default branch on '$remote' remote.")
                  .run())
              .printNotEmptyResultFields()
              .stdout
              .toString()
              .trim()
              .split('/');
      results.add((remote: remote, parts: result));
    }

    return defaultBranch = results
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
        ?.let((x) => x == 'HEAD' ? null : x);
  }
}
