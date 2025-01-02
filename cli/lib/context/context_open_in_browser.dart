import 'dart:io';

import 'package:stax/context/context.dart';
import 'package:stax/external_command/external_command.dart';

extension ContextOpenInBrowser on Context {
  ExternalCommand openInBrowser(String url) {
    final openCommand = Platform.isWindows
        ? ['PowerShell', '-Command', '''& {Start-Process "$url"}''']
        : ['open', url];

    return command(openCommand);
  }
}
