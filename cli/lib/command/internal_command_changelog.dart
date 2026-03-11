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
      final response = await http.get(Uri.parse(changelogUrl));
      if (response.statusCode == 200) {
        final currentVersion = InternalCommandVersion.version;
        final lines = response.body.split('\n');
        for (final line in lines) {
          if (line.contains(currentVersion)) {
            context.printToConsole('$line <-- current version');
          } else {
            context.printToConsole(line);
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
