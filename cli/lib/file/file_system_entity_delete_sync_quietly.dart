import 'dart:io';

extension FileSystemEntityDeleteSyncQuietly on FileSystemEntity {
  void deleteSyncQuietly({bool recursive = false}) {
    try {
      deleteSync(recursive: recursive);
    } catch (_) {
      // no op
    }
  }
}
