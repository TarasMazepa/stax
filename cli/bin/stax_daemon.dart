import 'dart:async';
import 'dart:io';
import 'package:stax/command/flag.dart';

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
      client.listen((data) {
        final command = String.fromCharCodes(data).trim();
        switch (command) {
          case 'exit':
            isRunning = false;
            break;
          case 'watch':
            _startGitWatcher(client);
            break;
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

void _startGitWatcher(Socket client) {
  final gitDir = Directory('.git');
  gitDir.watch(events: FileSystemEvent.all).listen((event) {
    final message = 'Git change detected: ${event.path} (${event.type})\n';
    client.write(message);
  });
}
