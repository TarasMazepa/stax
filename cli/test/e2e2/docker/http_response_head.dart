import 'package:meta/meta.dart';

@visibleForTesting
class HttpResponseHead {
  final int statusCode;
  final Map<String, String> headers; // lower-cased keys

  HttpResponseHead(this.statusCode, this.headers);

  int? get contentLength {
    final v = headers['content-length'];
    return v == null ? null : int.tryParse(v.trim());
  }

  bool get isChunked =>
      (headers['transfer-encoding'] ?? '').toLowerCase().contains('chunked');
}
