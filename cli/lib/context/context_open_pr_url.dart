import 'dart:io';
import 'package:stax/context/context.dart';

extension ContextOpenPrUrl on Context {
  void openPrUrl(String targetBranch, String currentBranch) {
    final remote = git.remote.runSync().stdout.toString().trim();
    if (remote.isEmpty) {
      printToConsole("Can't determine remote.");
      return;
    }

    final remoteUrl = git.remoteGetUrl
        .arg(remote)
        .runSync()
        .stdout
        .toString()
        .trim()
        .replaceFirstMapped(RegExp(r'git@(.*):'), (m) => 'https://${m[1]}/');

    if (remoteUrl.isEmpty) {
      printToConsole("Can't determine remote URL.");
      return;
    }

    final newPrUrl =
        '${remoteUrl.substring(0, remoteUrl.length - 4)}/compare/$targetBranch...$currentBranch?expand=1';

    final openCommand = () {
      if (Platform.isWindows) {
        return [
          'PowerShell',
          '-Command',
          '''& {Start-Process "$newPrUrl"}''',
        ];
      }
      return ['open', newPrUrl];
    }();

    command(openCommand)
        .announce('Opening PR creation page in browser')
        .runSync()
        .printNotEmptyResultFields();
  }
}
