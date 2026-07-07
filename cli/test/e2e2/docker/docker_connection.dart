import 'dart:io';

class DockerConnectionException implements Exception {
  final String message;
  DockerConnectionException(this.message);
  @override
  String toString() => 'DockerConnectionException: $message';
}

abstract class DockerConnection {
  Stream<List<int>> get incoming;
  void add(List<int> bytes);
  Future<void> flush();
  Future<void> close();
  static Future<DockerConnection> connect() {
    if (Platform.isWindows) {
      throw UnsupportedError(
        'Windows is not supported. Docker Engine API is currently implemented for Unix sockets only.',
      );
    }
    return UnixSocketConnection.connect('/var/run/docker.sock');
  }
}

class UnixSocketConnection implements DockerConnection {
  final Socket _socket;

  UnixSocketConnection(this._socket);

  static Future<DockerConnection> connect(String path) async {
    if (!File(path).existsSync() && !Link(path).existsSync()) {
      throw DockerConnectionException(
        'Docker socket not found at $path. Is the Docker daemon running?',
      );
    }
    try {
      final socket = await Socket.connect(
        InternetAddress(path, type: InternetAddressType.unix),
        0,
      );
      return UnixSocketConnection(socket);
    } on SocketException catch (e) {
      throw DockerConnectionException(
        'Failed to connect to $path: ${e.message}',
      );
    }
  }

  @override
  Stream<List<int>> get incoming => _socket;

  @override
  void add(List<int> bytes) => _socket.add(bytes);

  @override
  Future<void> flush() => _socket.flush();

  @override
  Future<void> close() async {
    try {
      await _socket.flush();
      await _socket.close();
    } finally {
      _socket.destroy();
    }
  }
}
