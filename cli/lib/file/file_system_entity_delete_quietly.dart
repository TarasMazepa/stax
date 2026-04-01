import 'dart:io';

extension FileSystemEntityDeleteQuietly on FileSystemEntity {
  Future<void> deleteQuietly({bool recursive = false}) async {
    try {
      await delete(recursive: recursive);
    } catch (_) {
      // no op
    }
  }
}
