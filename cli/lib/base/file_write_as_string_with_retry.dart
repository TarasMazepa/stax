import 'dart:convert';
import 'dart:io';

extension FileWriteAsStringWithRetry on File {
  Future<void> writeAsStringWithRetry(
    String contents, {
    FileMode mode = FileMode.write,
    Encoding encoding = utf8,
    bool flush = true,
    int retry = 3,
  }) async {
    dynamic toRethrow;
    for (int i = 0; i < retry && retry > 0; i++) {
      try {
        await create(recursive: true);
        await writeAsString(
          contents,
          mode: mode,
          encoding: encoding,
          flush: flush,
        );
        return;
      } catch (e) {
        toRethrow ??= e;
      }
    }
    throw toRethrow;
  }
}
