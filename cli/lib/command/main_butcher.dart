import 'dart:async';
import 'package:monolib_dart/monolib_dart.dart';

final Batcher<Future<void>> mainButcher = Batcher<Future<void>>(
  maxBatchSize: 1000000000,
  maxDuration: const Duration(days: 36500),
  onBatch: (List<Future<void>> batch) => batch.wait,
);
