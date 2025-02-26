import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/command/internal_command_version.dart';

class InternalCommandUpdate extends InternalCommand {
  InternalCommandUpdate()
      : super(
          'update',
          'Updates to the latest version.',
          type: InternalCommandType.hidden,
        );

  static const String versionUrl =
      'https://raw.githubusercontent.com/TarasMazepa/stax/refs/heads/main/VERSION';

  @override
  void run(final List<String> args, Context context) {
    if (Platform.isMacOS || Platform.isLinux) {
      updateViaHomebrew(context);
    } else {
      showInstallationInstructions(context);
    }
  }

  Future<bool> needsUpdate(Context context) async {
    try {
      final localVersion = InternalCommandVersion.version;

      final response = await http.get(Uri.parse(versionUrl));
      if (response.statusCode != 200) {
        context.printParagraph('Failed to fetch latest version from GitHub.');
        return false;
      }
      final remoteVersion = response.body.trim();

      context.printParagraph('Local version: $localVersion');
      context.printParagraph('Latest version: $remoteVersion');

      return localVersion != remoteVersion;
    } catch (e) {
      context.printParagraph('Error checking versions: $e');
      return false;
    }
  }

  void updateViaHomebrew(Context context) {
    context.printParagraph('Checking if stax is installed via Homebrew...');

    final brewCheckResult = context.command(['which', 'brew']).runSync();

    if (brewCheckResult.exitCode != 0) {
      context.printParagraph('Homebrew is not installed on this system.');
      showInstallationInstructions(context);
      return;
    }

    final brewListResult =
        context.command(['brew', 'list', '--formula']).runSync();

    if (brewListResult.exitCode != 0 ||
        !brewListResult.stdout.toString().contains('stax')) {
      context
          .printParagraph('stax is not installed via Homebrew on this system.');
      showInstallationInstructions(context);
      return;
    }

    context.printParagraph(
      'stax is installed via Homebrew. Checking for updates...',
    );

    needsUpdate(context).then((updateNeeded) {
      if (!updateNeeded) {
        context.printParagraph('stax is already at the latest version.');
        return;
      }

      context
          .command(['brew', 'update'])
          .announce('Updating Homebrew formulae...')
          .runSync()
          .printNotEmptyResultFields();

      context
          .printParagraph('A new version of stax is available. Upgrading...');

      final upgradeResult = context
          .command(['brew', 'upgrade', 'TarasMazepa/stax/stax'])
          .announce('Upgrading stax...')
          .runSync()
          .printNotEmptyResultFields();

      if (upgradeResult.exitCode == 0) {
        context.printParagraph(
          'stax has been successfully updated to the latest version.',
        );
      } else {
        context.printParagraph(
          'Failed to update stax. Please try again later or update manually using: brew upgrade TarasMazepa/stax/stax',
        );
      }
    });
  }

  void showInstallationInstructions(Context context) {
    context.printParagraph(
      'Please refer to the most recent installation instructions in the repository README file for accurate and up-to-date information. You can find the installation section here: https://github.com/TarasMazepa/stax?tab=readme-ov-file#installation',
    );
  }
}
