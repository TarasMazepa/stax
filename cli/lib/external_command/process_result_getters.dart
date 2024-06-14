import 'dart:io';

extension GettersOnProcessResult on ProcessResult {
  get stdoutString => switch (this.stdout) {
        String string => string,
        List<int> charCodes => String.fromCharCodes(charCodes),
        final other => other.toString()
      };
}
