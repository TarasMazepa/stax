import 'package:stax/command/internal_command.dart';
import 'package:stax/command/internal_command_exit.dart';

final List<InternalCommand> internalCommandsDaemon = [
  InternalCommandExit(),
]..sort();
