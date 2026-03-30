import 'package:collection/collection.dart';
import 'package:stax/context/context.dart';

extension ContextGitGetPreferredRemote on Context {
  static String? _preferredRemote;

  Future<String?> getPreferredRemote() async {
    final override = effectiveSettings.defaultRemote.value;
    if (override.isNotEmpty) return override;

    if (_preferredRemote != null) return _preferredRemote;

    final remotes =
        (await quietly().git.remote.announce('Getting remotes.').run())
            .printNotEmptyResultFields()
            .stdout
            .toString()
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

    _preferredRemote =
        remotes.firstWhereOrNull((x) => x == 'origin') ?? remotes.firstOrNull;

    return _preferredRemote;
  }
}
