import 'package:stax/command/internal_command.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';

class InternalCommandNuke extends InternalCommand {
  InternalCommandNuke()
    : super(
        'nuke',
        'Resets working directory and index to HEAD and cleans all untracked files.',
        type: InternalCommandType.hidden,
      );

  @override
  Future<void> run(final List<String> args, Context context) async {
    (await context.git.resetHardHead
            .announce('Resetting working directory to clean state')
            .run(onDemandPrint: true))
        .printNotEmptyResultFields();
    (await context.git.cleanFd
            .announce('Deleting all not tracked files')
            .run(onDemandPrint: true))
        .printNotEmptyResultFields();
  }
}
