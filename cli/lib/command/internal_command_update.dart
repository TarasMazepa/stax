import 'package:stax/command/internal_command.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';

class InternalCommandUpdate extends InternalCommand {
  InternalCommandUpdate()
      : super(
          'update',
          'Updates to the latest version.',
          type: InternalCommandType.hidden,
        );

  @override
  void run(final List<String> args, Context context) {
    context.printParagraph(
      'Please refer to the most recent installation instructions in the repository README file for accurate and up-to-date information. You can find the installation section here: https://github.com/TarasMazepa/stax?tab=readme-ov-file#installation',
    );
  }
}
