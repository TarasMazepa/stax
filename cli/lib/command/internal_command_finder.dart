import 'package:collection/collection.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/types_for_internal_command.dart';

extension OnIterableInternalCommand on Iterable<InternalCommand> {
  InternalCommand? findByNameOrPrefix(String commandName) {
    return firstWhereOrNull(
          (command) =>
              command.name == commandName || command.shortName == commandName,
        ) ??
        fold<InternalCommand?>(
          null,
          (current, command) => switch (command) {
            _ when !command.name.startsWith(commandName) => current,
            _ when current == null => command,
            _ when current.type.isHidden && command.type.isPublic => command,
            _ when current.name.length > command.name.length => command,
            _ when current.name.length < command.name.length => current,
            _ => current,
          },
        );
  }
}
