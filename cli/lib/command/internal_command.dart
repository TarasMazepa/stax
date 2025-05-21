import 'package:stax/command/flag.dart';
import 'package:stax/command/internal_command_help.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';

abstract class InternalCommand implements Comparable<InternalCommand> {
  final String name;
  final String? shortName;
  final String description;
  final InternalCommandType type;
  final Map<String, String>? arguments;
  final List<Flag>? flags;

  static final helpFlag = Flag(
    short: '-h',
    long: '--help',
    description: 'Shows help documentation for the command',
  );

  const InternalCommand(
    this.name,
    this.description, {
    this.shortName,
    this.type = InternalCommandType.public,
    this.arguments,
    this.flags,
  });

  void run(final List<String> args, final Context context);

  void runWraper(Function run, final List<String> args, final Context context) {
    bool hasHelpFlag = helpFlag.hasFlag(args);
    if (hasHelpFlag) {
      InternalCommandHelp().run([name], context);
      return;
    }
    run(args, context);
  }

  @override
  int compareTo(InternalCommand other) {
    return name.compareTo(other.name);
  }
}
