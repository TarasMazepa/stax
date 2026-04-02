import 'dart:async';
import 'package:monolib_dart/monolib_dart.dart';

final Batcher<Future<void>> mainButcher = Batcher<Future<void>>(
  onBatch: (List<Future<void>> batch) => batch.wait,
);
