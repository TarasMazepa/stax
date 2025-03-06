import 'dart:async';
import 'dart:io';

import 'package:stax/command/internal_command_exit.dart';
import 'package:stax/command/internal_commands_daemon.dart';
import 'package:stax/context/context.dart';

ServerSocket? _serverSocket;

bool _isRunning = true;

const int _daemonPort = 5000;

void main(List<String> arguments) async {
  final context = Context.implicit();

  context.printParagraph('Starting stax daemon on port $_daemonPort...');

  try {
    _serverSocket =
        await ServerSocket.bind(InternetAddress.loopbackIPv4, _daemonPort);

    _serverSocket!.listen((client) {
      client.listen(
        (data) {
          final command = String.fromCharCodes(data).trim();
          _handleCommand(command, client, context);
        },
        onDone: () => client.close(),
      );
    });

    while (_isRunning) {
      await Future.delayed(Duration(seconds: 1));
    }
  } catch (e) {
    context.printParagraph('Error: $e');
    exit(1);
  } finally {
    await _serverSocket?.close();
    context.printParagraph('Daemon shut down');
  }
}

void _handleCommand(
  String commandString,
  Socket client,
  Context context,
) {
  final parts = commandString.split(' ');
  if (parts.isEmpty) return;

  final commandName = parts.first;
  final args = parts.length > 1 ? parts.sublist(1) : <String>[];

  final internalCommand = internalCommandsDaemon
      .where((cmd) => cmd.name == commandName || cmd.shortName == commandName)
      .firstOrNull;

  if (internalCommand != null) {
    client.writeln('\nExecuting command: ${internalCommand.name}\n');
    internalCommand.run(args, context);

    if (internalCommand is InternalCommandExit) {
      stopDaemon();
    }
    return;
  }

  client.writeln('Unknown command: $commandName');
}

void stopDaemon() {
  _isRunning = false;
}
