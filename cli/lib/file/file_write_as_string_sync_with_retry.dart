import 'dart:convert';
import 'dart:io';

extension FileWriteAsStringSyncWithRetry on File {
  void writeAsStringSyncWithRetry(
    String contents, {
    FileMode mode = FileMode.write,
    Encoding encoding = utf8,
    bool flush = true,
    int retry = 3,
  }) {
    dynamic error;
    for (int i = 0; i < retry && retry > 0; i++) {
      try {
        writeAsStringSync(
          contents,
          mode: mode,
          encoding: encoding,
          flush: flush,
        );
        return;
      } catch (e) {
        error ??= e;
      }
    }
    throw error;
  }
}
