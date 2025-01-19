import 'dart:convert';
import 'dart:io';

extension UriLoadSettings on Uri {
  T loadSettings<T>(T Function(Map<String, dynamic>, File) creator) {
    final file = File.fromUri(this);
    dynamic error;
    for (int i = 0; i < 3; i++) {
      if (!file.existsSync()) {
        file.createSync(recursive: true);
        file.writeAsStringSync('{}', flush: true);
      }
      try {
        return creator(jsonDecode(file.readAsStringSync()), file);
      } catch (e) {
        file.deleteSync();
        error ??= e;
      }
    }
    throw error;
  }
}
