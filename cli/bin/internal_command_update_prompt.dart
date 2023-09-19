import 'context_for_internal_command.dart';
import 'internal_command.dart';
import 'types_for_internal_command.dart';

class InternalCommandUpdatePrompt extends InternalCommand {
  InternalCommandUpdatePrompt()
      : super("update-prompt", "Asks about updating.",
            type: InternalCommandType.hidden);

  @override
  void run(ContextForInternalCommand context) {}
}
