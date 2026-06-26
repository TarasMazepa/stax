import 'dart:async';
import 'dart:io';

import 'package:test/test.dart';

import 'base/e2e_group.dart';

extension WriteAsyncOnIOSink on IOSink {
  Future<IOSink> writeLineAndFlush([Object? object = '']) async {
    writeln(object);
    await flush();
    return this;
  }
}

extension WriteAsyncOnFutureIOSink on Future<IOSink> {
  Future<IOSink> writeLineAndFlush([Object? object = '']) {
    return then((ioSink) {
      return ioSink.writeLineAndFlush(object);
    });
  }
}

void main() {
  e2eGroup('about', skip: true, (processGetter) {
    test('about', () async {
      final process = processGetter();
      process.stdin.writeln('stax about');
      await process.stdin.flush();
      sleep(Duration(seconds: 2));
      process.stdin.writeln('stax about');
      await process.stdin.flush();
      sleep(Duration(seconds: 2));
    });
  });
}
