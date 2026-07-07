import 'dart:async';
import 'dart:convert';

import 'docker_api_client.dart';
import 'docker_connection.dart';

class InteractiveStaxSession {
  final DockerApiClient _client;
  final String execId;
  final DockerConnection _connection;

  final StreamController<String> _output = StreamController<String>.broadcast();
  final StringBuffer _accumulated = StringBuffer();
  final List<_Waiter> _waiters = [];

  late final StreamSubscription<String> _sub;
  bool _closed = false;

  InteractiveStaxSession(
    this._client,
    this.execId,
    this._connection,
    Stream<List<int>> rawStream,
  ) {
    _sub = rawStream
        .transform(utf8.decoder)
        .listen(
          (chunk) {
            _accumulated.write(chunk);
            if (!_output.isClosed) _output.add(chunk);
            _checkWaiters();
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
  }) {
    if (_accumulated.toString().contains(pattern)) {
      return Future.value(_accumulated.toString());
    }
    if (_output.isClosed) {
      return Future.error(
        StateError(
          'Session closed before "$pattern" appeared.\n'
          'Output was:\n${_accumulated.toString()}',
        ),
      );
    }
    final waiter = _Waiter(pattern);
    waiter.timer = Timer(timeout, () {
      _waiters.remove(waiter);
      waiter.completer.completeError(
        TimeoutException(
          'Timed out after $timeout waiting for "$pattern".\n'
          'Output so far:\n${_accumulated.toString()}',
        ),
      );
    });
    _waiters.add(waiter);
    return waiter.completer.future;
  }

  Future<int?> exitCode() => _client.inspectExecExitCode(execId);

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    for (final w in _waiters) {
      w.timer?.cancel();
      if (!w.completer.isCompleted) {
        w.completer.completeError(StateError('Session closed'));
      }
    }
    _waiters.clear();
    await _sub.cancel();
    if (!_output.isClosed) await _output.close();
    await _connection.close();
  }

  void _handleDone() {
    for (final w in List<_Waiter>.from(_waiters)) {
      w.timer?.cancel();
      if (!w.completer.isCompleted) {
        w.completer.completeError(
          StateError(
            'Session ended before "${w.pattern}" appeared.\n'
            'Output was:\n${_accumulated.toString()}',
          ),
        );
      }
    }
    _waiters.clear();
    if (!_output.isClosed) unawaited(_output.close());
  }

  void _checkWaiters() {
    if (_waiters.isEmpty) return;
    final snapshot = _accumulated.toString();
    _waiters.removeWhere((w) {
      if (snapshot.contains(w.pattern)) {
        w.timer?.cancel();
        w.completer.complete(snapshot);
        return true;
      }
      return false;
    });
  }

  void _ensureOpen() {
    if (_closed) throw StateError('Session is closed');
  }
}

class _Waiter {
  final Pattern pattern;
  final Completer<String> completer = Completer<String>();
  Timer? timer;

  _Waiter(this.pattern);
}
