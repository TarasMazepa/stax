import 'dart:convert';
import 'dart:io';

import 'package:monolib_dart/monolib_dart.dart';

extension FileReadAsStringSyncWithRetry on File {
  String readAsStringSyncWithRetry({Encoding encoding = utf8, int retry = 3}) {
    return (() => readAsStringSync(
      encoding: encoding,
    )).callWithRetryOnFailure(times: retry);
  }
}
