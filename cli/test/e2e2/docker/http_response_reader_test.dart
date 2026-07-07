import 'dart:async';
import 'dart:convert';

import 'package:test/test.dart';

import 'http_response_reader.dart';

void main() {
  group('HttpResponseReader', () {
    test('parses status line and headers', () async {
      final source = StreamController<List<int>>();
      final reader = HttpResponseReader(source.stream);
      source.add(
        utf8.encode(
          'HTTP/1.1 201 Created\r\n'
          'Content-Type: application/json\r\n'
          'Content-Length: 13\r\n'
          '\r\n'
          '{"Id":"abc"}\n',
        ),
      );

      final head = await reader.readHead();
      expect(head.statusCode, 201);
      expect(head.contentLength, 13);
      expect(head.headers['content-type'], 'application/json');

      final body = await reader.readBody(head);
      expect(jsonDecode(utf8.decode(body))['Id'], 'abc');
      await source.close();
    });

    test('handles a header block split across multiple chunks', () async {
      final source = StreamController<List<int>>();
      final reader = HttpResponseReader(source.stream);
      source.add(utf8.encode('HTTP/1.1 200 OK\r\nContent-Length: 2\r'));
      source.add(utf8.encode('\n\r\nhi'));

      final head = await reader.readHead();
      expect(head.statusCode, 200);
      expect(utf8.decode(await reader.readBody(head)), 'hi');
      await source.close();
    });

    test('reads a chunked body', () async {
      final source = StreamController<List<int>>();
      final reader = HttpResponseReader(source.stream);
      source.add(
        utf8.encode(
          'HTTP/1.1 200 OK\r\n'
          'Transfer-Encoding: chunked\r\n'
          '\r\n'
          '5\r\nhello\r\n'
          '6\r\n world\r\n'
          '0\r\n\r\n',
        ),
      );

      final head = await reader.readHead();
      expect(head.isChunked, isTrue);
      expect(utf8.decode(await reader.readBody(head)), 'hello world');
      await source.close();
    });

    test(
      'releaseRawStream emits already-buffered and future bytes in order',
      () async {
        final source = StreamController<List<int>>();
        final reader = HttpResponseReader(source.stream);
        source.add(
          utf8.encode(
            'HTTP/1.1 101 UPGRADED\r\n'
            'Content-Type: application/vnd.docker.raw-stream\r\n'
            'Connection: Upgrade\r\n'
            'Upgrade: tcp\r\n'
            '\r\n'
            'already-here',
          ),
        );

        final head = await reader.readHead();
        expect(head.statusCode, 101);

        final raw = reader.releaseRawStream();
        final collected = StringBuffer();
        final sub = raw.transform(utf8.decoder).listen(collected.write);
        source.add(utf8.encode('-and-more'));
        await source.close();
        await sub.asFuture<void>();

        expect(collected.toString(), 'already-here-and-more');
      },
    );
  });
}
