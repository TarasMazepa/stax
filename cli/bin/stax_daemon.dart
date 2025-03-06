import 'dart:async';
import 'dart:io';

import 'package:stax/context/context.dart';

void main(List<String> arguments) async {
  final daemonPort = 5000;
  context.printParagraph('Starting stax daemon on port $daemonPort...');

  ServerSocket? serverSocket;
  try {
    serverSocket = await ServerSocket.bind(
      InternetAddress.loopbackIPv4,
      daemonPort,
    );

    bool isRunning = true;
    serverSocket!.listen((client) {
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
  } catch (e) {
    context.printParagraph('Error: $e');
    exit(1);
  } finally {
    await serverSocket?.close();
    context.printParagraph('Daemon shut down');
  }
}
