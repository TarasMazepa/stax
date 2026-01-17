import 'dart:io';

void main() {
  final valid = <String>[];
  for (int i = 40; ; i++) {
    final success =
        Process.runSync('git', [
          'switch',
          '-c',
          String.fromCharCode(i),
        ], workingDirectory: '/Users/tarasmazepa/test').exitCode ==
        0;
    if (success) {
      valid.add(String.fromCharCode(i));
      Process.runSync('git', [
        'branch',
        '-D',
        String.fromCharCode(i),
      ], workingDirectory: '/Users/tarasmazepa/test');
    }
    if (i % 10 == 0) {
      print(valid.join());
    }
  }
}
