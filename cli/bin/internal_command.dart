import 'package:stax/context/context.dart';

import 'types_for_internal_command.dart';

abstract class InternalCommand implements Comparable<InternalCommand> {
  final String name;
  final String description;
  final InternalCommandType type;
  final Map<String, String>? arguments;
  final Map<String, String>? flags;

  const InternalCommand(this.name, this.description,
      {this.type = InternalCommandType.public, this.arguments, this.flags});

  void run(final List<String> args, final Context context);

  @override
  int compareTo(InternalCommand other) {
    return name.compareTo(other.name);
  }
}
