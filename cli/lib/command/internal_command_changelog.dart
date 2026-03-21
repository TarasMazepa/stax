import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/internal_command_version.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';

class InternalCommandChangelog extends InternalCommand {
  static const String changelogUrl =
      'https://raw.githubusercontent.com/TarasMazepa/stax/refs/heads/main/CHANGELOG.md';

  InternalCommandChangelog()
    : super(
        'changelog',
        'Shows the stax changelog.',
        type: InternalCommandType.hidden,
      );

  @override
  Future<void> run(final List<String> args, Context context) async {
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
            if (entries > 5) break;
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
