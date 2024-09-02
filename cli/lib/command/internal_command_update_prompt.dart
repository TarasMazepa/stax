import 'dart:io';

import 'package:http/http.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/internal_command_version.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';

class InternalCommandUpdatePrompt extends InternalCommand {
  InternalCommandUpdatePrompt()
      : super(
          "update-prompt",
          "Asks about updating.",
          type: InternalCommandType.hidden,
        );

  @override
  Future<void> run(final List<String> args, Context context) async {
    List<int>? parseVersion(String? version) {
      try {
        return version?.split(".").map(int.parse).toList();
      } catch (e) {
        return null;
      }
    }

    final localVersion = parseVersion(InternalCommandVersion.version);

    if (localVersion == null) {
      context.printToConsole(
        "Can't parse own version '${InternalCommandVersion.version}'",
      );
      return;
    }

    final responseBody = (await get(
      Uri.parse(
        Platform.isWindows
            ? "https://community.chocolatey.org/api/v2/Packages()?%24filter=Id%20eq%20%27stax%27&%24orderby=Published%20desc&%24top=1"
            : "https://raw.githubusercontent.com/TarasMazepa/homebrew-stax/main/Formula/stax.rb",
      ),
    ))
        .body;

    final remoteVersion = parseVersion(
      RegExp(
        Platform.isWindows ? r"Version>(.*)</" : r"version '(.*)'",
      ).firstMatch(responseBody)?.group(1),
    );

    if (remoteVersion == null) {
      context.printToConsole("Can't parse latest online version");
      return;
    }

    for (int i = 0; i < remoteVersion.length; i++) {
      if (remoteVersion[i] > localVersion[i]) {
        context.printToConsole(
          "New stax version is available - ${remoteVersion.join(".")}. Run following command to update:",
        );
        context.printParagraph(
          Platform.isWindows ? "choco upgrade stax" : "brew upgrade stax",
        );
        return;
      }
    }

    context.printToConsole("You are up to date!");
  }
}
