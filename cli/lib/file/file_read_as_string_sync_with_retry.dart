import 'dart:convert';
import 'dart:io';

extension FileReadAsStringSyncWithRetry on File {
  String readAsStringSyncWithRetry({Encoding encoding = utf8, int retry = 3}) {
    dynamic error;
    for (int i = 0; i < retry && retry > 0; i++) {
      try {
        return readAsStringSync(encoding: encoding);
      } catch (e) {
        error ??= e;
      }
    }
    throw error;
  }
}
