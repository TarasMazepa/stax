import 'package:stax/command/internal_command.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';

class InternalCommandExit extends InternalCommand {
  InternalCommandExit()
    : super(
        'exit',
        'Exits the stax daemon',
        shortName: 'e',
        type: InternalCommandType.public,
      );

  @override
  void run(final List<String> args, final Context context) {
    context.printParagraph('Exiting daemon...');
  }
}
