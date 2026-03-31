import 'dart:convert';
import 'dart:io';

import 'package:monolib_dart/monolib_dart.dart';

extension FileWriteAsStringWithRetry on File {
  Future<void> writeAsStringWithRetry(
    String contents, {
    FileMode mode = FileMode.write,
    Encoding encoding = utf8,
    bool flush = true,
    int retry = 3,
  }) async {
    await (() async {
      await create(recursive: true);
      await writeAsString(
        contents,
        mode: mode,
        encoding: encoding,
        flush: flush,
      );
    }).callWithRetryOnFailure(times: retry);
  }
}
