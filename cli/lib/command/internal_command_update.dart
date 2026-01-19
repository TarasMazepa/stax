import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/internal_command_version.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';

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
  Future<void> run(final List<String> args, Context context) async {
    final isMacOsOrLinux = Platform.isMacOS || Platform.isLinux;
    if (!isMacOsOrLinux) {
      _showInstallationInstructions(context);
      return;
    }
    context.printToConsole('Checking if stax is installed via Homebrew...');

    final brewCheckResult = context.command(['which', 'brew']).runSync();

    if (brewCheckResult.exitCode != 0) {
      context.printToConsole('Homebrew is not installed on this system.');
      _showInstallationInstructions(context);
      return;
    }

    final brewListResult = context.command([
      'brew',
      'list',
      '--formula',
    ]).runSync();

    if (brewListResult.exitCode != 0 ||
        !brewListResult.stdout.toString().contains('stax')) {
      context.printToConsole(
        'stax is not installed via Homebrew on this system.',
      );
      _showInstallationInstructions(context);
      return;
    }

    context.printToConsole(
      'stax is installed via Homebrew. Checking for updates...',
    );

    final updateNeeded = await needsUpdate(context);
    if (!updateNeeded) {
      context.printToConsole('stax is already at the latest version.');
      return;
    }

    context
        .command(['brew', 'update'])
        .announce('Updating Homebrew formulae...')
        .runSync()
        .printNotEmptyResultFields();

    context.printToConsole('A new version of stax is available. Upgrading...');

    final upgradeResult = context
        .command(['brew', 'upgrade', 'TarasMazepa/stax/stax'])
        .announce('Upgrading stax...')
        .runSync()
        .printNotEmptyResultFields();

    if (upgradeResult.exitCode == 0) {
      context.printToConsole(
        'stax has been successfully updated to the latest version.',
      );
    } else {
      context.printToConsole(
        'Failed to update stax. Please try again later or update manually using: brew upgrade TarasMazepa/stax/stax',
      );
    }
  }

  Future<bool> needsUpdate(Context context) async {
    final localVersion = InternalCommandVersion.version;

    final response = await http.get(Uri.parse(versionUrl));
    if (response.statusCode != 200) {
      context.printToConsole('Failed to fetch latest version from GitHub.');
      return false;
    }
    final remoteVersion = response.body.trim();

    context.printToConsole('Local version: $localVersion');
    context.printToConsole('Latest version: $remoteVersion');

    return localVersion != remoteVersion;
  }

  void _showInstallationInstructions(Context context) {
    context.printParagraph(
      'Please refer to the most recent installation instructions in the '
      'repository README file for accurate and up-to-date information. You can '
      'find the installation section here: '
      'https://github.com/TarasMazepa/stax?tab=readme-ov-file#installation',
    );
  }
}
