import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'docker_api_client.dart';

class InteractiveStaxSession {
  final DockerApiClient _client;
  final String execId;
  final Socket _connection;

  final StreamController<String> _output = StreamController<String>.broadcast();
  final StringBuffer _accumulated = StringBuffer();

  late final StreamSubscription<String> _sub;
  bool _closed = false;

  InteractiveStaxSession(
    this._client,
    this.execId,
    this._connection,
    Stream<List<int>> rawStream,
  ) {
    _sub = rawStream
        .cast<List<int>>()
        .transform(utf8.decoder)
        .listen(
          (chunk) {
            _accumulated.write(chunk);
            if (!_output.isClosed) _output.add(chunk);
          },
          onError: (Object e, StackTrace st) {
            if (!_output.isClosed) _output.addError(e, st);
          },
          onDone: _handleDone,
        );
  }

  Stream<String> get output => _output.stream;

  String get outputSoFar => _accumulated.toString();

  Future<void> get done => _output.done;

  void send(String input) {
    _ensureOpen();
    _connection.add(utf8.encode(input));
  }

  void sendLine(String input) => send('$input\r');

  void sendBytes(List<int> bytes) {
    _ensureOpen();
    _connection.add(bytes);
  }

  Future<String> waitFor(
    Pattern pattern, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final current = _accumulated.toString();
    if (current.contains(pattern)) return current;
    if (_output.isClosed)
      throw StateError('Session closed before "$pattern" appeared.');
    return await _output.stream
        .map((_) => _accumulated.toString())
        .firstWhere((s) => s.contains(pattern))
        .timeout(
          timeout,
          onTimeout: () =>
              throw TimeoutException('Timed out waiting for "$pattern"'),
        );
  }

  Future<int?> exitCode() => _client.inspectExecExitCode(execId);

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _sub.cancel();
    if (!_output.isClosed) await _output.close();
    await _connection.closeSafely();
  }

  void _handleDone() {
    if (!_output.isClosed) unawaited(_output.close());
  }

  void _ensureOpen() {
    if (_closed) throw StateError('Session is closed');
  }
}
