import 'dart:convert';
import 'dart:io';

import 'package:monolib_dart/monolib_dart.dart';

extension FileWriteAsStringSyncWithRetry on File {
  void writeAsStringSyncWithRetry(
    String contents, {
    FileMode mode = FileMode.write,
    Encoding encoding = utf8,
    bool flush = true,
    int retry = 3,
  }) {
    (() {
      createSync(recursive: true);
      writeAsStringSync(contents, mode: mode, encoding: encoding, flush: flush);
    }).callWithRetryOnFailure(times: retry);
  }
}
