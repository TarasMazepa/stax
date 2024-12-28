import 'dart:io';

import 'package:stax/context/context.dart';

extension ContextOpenInBrowser on Context {
  void openInBrowser(String url) {
    final openCommand = Platform.isWindows
        ? ['PowerShell', '-Command', '''& {Start-Process "$url"}''']
        : ['open', url];

    command(openCommand)
        .announce('Opening URL in browser')
        .runSync()
        .printNotEmptyResultFields();
  }
}
