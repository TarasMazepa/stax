import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stax/command/flag.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/internal_command_version.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';

class InternalCommandChangelog extends InternalCommand {
  static const String changelogUrl =
      'https://raw.githubusercontent.com/TarasMazepa/stax/refs/heads/main/CHANGELOG.md';

  static final Flag versionsFlag = Flag(
    short: '-s',
    long: '--show-only-latest',
    description: 'show specific amount of versions',
  );

  InternalCommandChangelog()
    : super(
        'changelog',
        'Shows the stax changelog.',
        type: InternalCommandType.hidden,
        flags: [versionsFlag],
      );

  @override
  Future<void> run(final List<String> args, Context context) async {
    // We use a safe max value because Dart compiles to JS and can't use 2^63 safely.
    // So 9007199254740991 (Number.MAX_SAFE_INTEGER) is a good safe maximum.
    const safeMaxInt = 9007199254740991;
    late final int limit;
    try {
      limit = switch (versionsFlag.getOptionalFlagValue(args)) {
        FlagPresent(:final value?) => int.parse(value),
        FlagPresent() => safeMaxInt,
        _ => 5,
      };
    } catch (e) {
      context.printParagraph('Failed to parse versions limit.');
      return;
    }

    try {
      final request = http.Request('GET', Uri.parse(changelogUrl));
      final response = await request.send();

      if (response.statusCode == 200) {
        final currentVersion = InternalCommandVersion.version;
        int entries = 0;
        final versionRegex = RegExp(r'\d+\.\d+\.\d+');
        await for (final chunk
            in response.stream
                .transform(utf8.decoder)
                .transform(const LineSplitter())) {
          if (versionRegex.matchAsPrefix(chunk) != null) {
            entries++;
            if (entries > limit) break;
          }
          if (chunk.startsWith(currentVersion)) {
            context.printToConsole('$chunk <-- current version');
          } else {
            context.printToConsole(chunk);
          }
        }
      } else {
        context.printParagraph(
          'Failed to fetch changelog. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      context.printParagraph('Failed to fetch changelog. Error: $e');
    }
  }
}
