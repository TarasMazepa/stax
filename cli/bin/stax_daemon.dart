import 'dart:async';
import 'dart:io';
import 'package:stax/command/flag.dart';
import 'package:stax/daemon/commands/handler.dart';

void main(List<String> arguments) async {
  int daemonPort = 62261;
  final portFlag = Flag(
    short: '-p',
    long: '--port',
    description: 'Port to run the daemon on',
  );

  final portValue = portFlag.getFlagValue(arguments);
  if (portValue != null) daemonPort = int.tryParse(portValue) ?? daemonPort;

  print('Starting stax daemon on port $daemonPort...');

  ServerSocket? serverSocket;
  try {
    serverSocket = await ServerSocket.bind(
      InternetAddress.loopbackIPv4,
      daemonPort,
    );

    bool isRunning = true;
    serverSocket.listen((client) {
      client.listen((data) async {
        final rawCommand = String.fromCharCodes(data).trim();
        if (await CommandHandler.handle(client, rawCommand)) {
          isRunning = true;
        }
      }, onDone: () => client.close());
    });

    while (isRunning) {
      await Future.delayed(Duration(seconds: 1));
    }
  } finally {
    await serverSocket?.close();
    print('Daemon shut down');
  }
}
