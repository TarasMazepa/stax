import 'dart:io';

class DockerConnection {
  final Socket _socket;

  DockerConnection._(this._socket);

  Stream<List<int>> get incoming => _socket;

  void add(List<int> bytes) => _socket.add(bytes);

  Future<void> flush() => _socket.flush();

  Future<void> close() async {
    try {
      await _socket.flush();
      await _socket.close();
    } finally {
      _socket.destroy();
    }
  }

  static Future<DockerConnection> connect() async {
    if (Platform.isWindows) {
      throw UnsupportedError(
        'Windows is not supported. Docker Engine API is currently implemented for Unix sockets only.',
      );
    }
    const path = '/var/run/docker.sock';
    if (!File(path).existsSync() && !Link(path).existsSync()) {
      throw Exception(
        'Docker socket not found at $path. Is the Docker daemon running?',
      );
    }
    try {
      final socket = await Socket.connect(
        InternetAddress(path, type: InternetAddressType.unix),
        0,
      );
      return DockerConnection._(socket);
    } on SocketException catch (e) {
      throw Exception(
        'Failed to connect to $path: ${e.message}',
      );
    }
  }
}
