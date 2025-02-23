import 'package:stax/nullable_index_of.dart';

class Flag {
  final String? short;
  final String? long;
  final String description;

  Flag({this.short, this.long, required this.description})
      : assert(
          short != null || long != null,
          'Either short or long should be not null',
        ),
        assert(
          short == null || (short.startsWith('-') && short.length == 2),
          "Short should have format '-x', where x is a single symbol",
        ),
        assert(
          long == null || (long.startsWith('--') && long.length > 2),
          "Long should have format '--xxx', where xxx is a long name of the flag",
        );

  String get shortOrLong => (short ?? long)!;

  bool hasFlag(List<String> args) {
    return switch ((short, long)) {
      (_, String long) when args.remove(long) => true,
      (String short, _) when args.remove(short) => true,
      (null, _) => false,
      (String short, _) => () {
          for (int i = 0; i < args.length; i++) {
            final arg = args[i];
            if (arg.length < 2) continue;
            if (arg[0] != '-') continue;
            if (arg[1] == '-') continue;
            final newArg = arg.replaceFirst(short[1], '');
            if (newArg.length < arg.length) {
              args[i] = newArg;
              return true;
            }
          }
          return false;
        }(),
    };
  }

  String? getFlagValue(List<String> args) {
    if (long != null) {
      final index = args.indexOf(long!).toNullableIndexOfResult();
      if (index != null) {
        final valueIndex = index + 1;
        if (args.length <= valueIndex) {
          throw Exception("Value wasn't provided for '$long' flag.");
        }
        return args[valueIndex];
      }
    }
    if (short != null) {
      final index = args.indexOf(short!).toNullableIndexOfResult();
      if (index != null) {
        final valueIndex = index + 1;
        if (args.length <= valueIndex) {
          throw Exception("Value wasn't provided for '$short' flag.");
        }
        return args[valueIndex];
      }
    }
    return null;
  }

  @override
  String toString() {
    return "${[short, long].nonNulls.join(", ")} - $description";
  }
}
