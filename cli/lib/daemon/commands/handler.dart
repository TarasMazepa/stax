import 'dart:io';
import 'package:stax/daemon/commands.dart';
import 'package:stax/daemon/commands/base_command.dart';

class CommandHandler {
  static final Map<String, DaemonCommand> _commands = {'watch': WatchCommand()};

  static Future<bool> handle(Socket client, String rawCommand) async {
    final parts = rawCommand.split(' ');
    final commandName = parts[0].toLowerCase();

    if (commandName == 'exit') {
      return true;
    }

    final command = _commands[commandName];
    if (command == null) {
      client.write('Unknown command: $commandName\n');
      return false;
    }

    parts.removeAt(0);
    final args = parts.join(' ').split('=');
    print(args);
    await command.execute(client, args);
    return false;
  }
}
