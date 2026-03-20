import 'package:stax/nullable_index_of.dart';

sealed class OptionalFlagResult {}

class FlagNotPresent extends OptionalFlagResult {}

class FlagPresent extends OptionalFlagResult {
  final String? value;
  FlagPresent(this.value);
}

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
    final result = getOptionalFlagValue(args);
    if (result is FlagPresent) {
      if (result.value == null) {
        throw Exception("Value wasn't provided for '${long ?? short}' flag.");
      }
      return result.value;
    }
    return null;
  }

  OptionalFlagResult getOptionalFlagValue(List<String> args) {
    if (long != null) {
      final index = args.indexOf(long!).toNullableIndexOfResult();
      if (index != null) {
        args.removeAt(index);
        if (args.length > index) {
          final nextArg = args[index];
          args.removeAt(index);
          return FlagPresent(nextArg);
        }
        return FlagPresent(null);
      }
    }

    if (short != null) {
      for (int i = 0; i < args.length; i++) {
        final arg = args[i];
        if (arg.length < 2) continue;
        if (arg[0] != '-') continue;
        if (arg[1] == '-') continue;
        final newArg = arg.replaceFirst(short![1], '');
        if (newArg.length < arg.length) {
          if (newArg == '-') {
            args.removeAt(i);
            if (args.length > i) {
              final nextArg = args[i];
              args.removeAt(i);
              return FlagPresent(nextArg);
            }
            return FlagPresent(null);
          } else {
            args[i] = newArg;
            return FlagPresent(
              null,
            ); // The flag was combined (e.g., -av). No value supported for combined flags.
          }
        }
      }
    }

    return FlagNotPresent();
  }

  @override
  String toString() {
    return "${[short, long].nonNulls.join(", ")} - $description";
  }
}
