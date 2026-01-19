import 'package:stax/command/flag.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';

abstract class InternalCommand implements Comparable<InternalCommand> {
  final String name;
  final String? shortName;
  final String description;
  final InternalCommandType type;
  final Map<String, String>? arguments;
  final List<Flag>? flags;

  const InternalCommand(
    this.name,
    this.description, {
    this.shortName,
    this.type = InternalCommandType.public,
    this.arguments,
    this.flags,
  });

  Future<void> run(final List<String> args, final Context context);

  @override
  int compareTo(InternalCommand other) {
    return name.compareTo(other.name);
  }
}
