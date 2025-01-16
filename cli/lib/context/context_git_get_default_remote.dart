import 'package:stax/context/context.dart';
import 'package:stax/settings/settings.dart';

extension ContextGitGetDefaultRemote on Context {
  String? getDefaultRemote() {
    final override = Settings.instance.defaultRemote.value;
    if (override.isNotEmpty) return override;

    return withSilence(true)
        .git
        .remote
        .announce('Getting remotes.')
        .runSync()
        .printNotEmptyResultFields()
        .stdout
        .toString()
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .firstOrNull;
  }
}
