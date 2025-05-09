import 'dart:async';
import 'dart:io';

void main(List<String> arguments) async {
  final daemonPort = 5000;
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
