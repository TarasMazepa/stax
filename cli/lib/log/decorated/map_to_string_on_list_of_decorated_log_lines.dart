import 'package:stax/log/decorated/decorated_log_line.dart';

extension MapToStringOnListOfDecoratedLogLines on List<DecoratedLogLine> {
  Iterable<String> mapToString() {
    final alignment = map((e) => e.getAlignment())
        .reduce((value, element) => value + element);
    return map((e) => e.decorateToString(alignment));
  }
}
