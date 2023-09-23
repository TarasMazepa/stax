import 'package:stax/context/context_for_internal_command.dart';

import 'types_for_internal_command.dart';

abstract class InternalCommand implements Comparable<InternalCommand> {
  final String name;
  final String description;
  final InternalCommandType type;

  const InternalCommand(this.name, this.description,
      {this.type = InternalCommandType.public});

  void run(final ContextForInternalCommand context);

  @override
  int compareTo(InternalCommand other) {
    return name.compareTo(other.name);
  }
}
