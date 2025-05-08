import 'dart:async';
import 'dart:io';

void main(List<String> arguments) async {
  int daemonPort = 62261;

  for (int i = 0; i < arguments.length; i++) {
    if (arguments[i] == '-p' && i + 1 < arguments.length) {
      daemonPort = int.tryParse(arguments[i + 1]) ?? 5000;
      break;
    }
  }

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
        switch (String.fromCharCodes(data).trim()) {
          case 'exit':
            isRunning = false;
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
