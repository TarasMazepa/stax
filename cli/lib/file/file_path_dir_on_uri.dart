import 'package:path/path.dart';

extension FilePathDirOnUri on Uri {
  String toFilePathDir() {
    return dirname(toFilePath());
  }
}
