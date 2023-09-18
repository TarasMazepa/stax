import 'arguments_for_internal_command.dart';

abstract class InternalCommand {
  final String name;
  final String description;

  const InternalCommand(this.name, this.description);

  void run(final ArgumentsForInternalCommand arguments);
}
