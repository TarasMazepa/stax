import 'dart:io';

import 'package:http/http.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/internal_command_version.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';

class InternalCommandUpdatePrompt extends InternalCommand {
  InternalCommandUpdatePrompt()
    : super(
        'update-prompt',
        'Asks about updating.',
        type: InternalCommandType.hidden,
      );

  @override
  Future<void> run(final List<String> args, Context context) async {
    List<int>? parseVersion(String? version) {
      try {
        return version?.split('.').map(int.parse).toList();
      } catch (e) {
        return null;
      }
    }

    final localVersionRaw = InternalCommandVersion.version;

    final localVersion = parseVersion(localVersionRaw);

    if (localVersion == null) {
      context.printToConsole("Can't parse own version '$localVersionRaw'");
      return;
    }

    final responseBody =
        (await get(
          Uri.parse(
            Platform.isWindows
                ? 'https://community.chocolatey.org/api/v2/Packages()?%24filter=Id%20eq%20%27stax%27&%24orderby=Published%20desc&%24top=1'
                : 'https://raw.githubusercontent.com/TarasMazepa/homebrew-stax/main/Formula/stax.rb',
          ),
        )).body;

    final remoteVersionRaw = RegExp(
      Platform.isWindows ? r'Version>(.*)</' : r"version '(.*)'",
    ).firstMatch(responseBody)?.group(1);

    final remoteVersion = parseVersion(remoteVersionRaw);

    if (remoteVersion == null) {
      context.printToConsole(
        "Can't parse latest online version '$remoteVersionRaw'",
      );
      return;
    }

    context.printToConsole('Current version: $localVersionRaw');
    context.printToConsole('Latest  version: $remoteVersionRaw');

    for (int i = 0; i < remoteVersion.length; i++) {
      if (remoteVersion[i] > (localVersion.elementAtOrNull(i) ?? 0)) {
        context.printToConsole('Run following command to update:');
        context.printParagraph(
          Platform.isWindows
              ? 'choco upgrade stax'
              : 'brew update ; brew upgrade stax',
        );
        return;
      }
    }

    context.printToConsole('You are up to date!');
  }
}
