import 'dart:io';

extension FileSystemEntityDeleteSyncSilently on FileSystemEntity {
  void deleteSyncSilently({bool recursive = false}) {
    try {
      deleteSync(recursive: recursive);
    } catch (_) {
      // no op
    }
  }
}
