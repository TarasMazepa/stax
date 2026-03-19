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
    String? getFlagValueInternal(String? flag) {
      if (flag == null) return null;
      final index = args.indexOf(flag).toNullableIndexOfResult();
      if (index == null) return null;
      final valueIndex = index + 1;
      if (args.length <= valueIndex) {
        throw Exception("Value wasn't provided for '$long' flag.");
      }
      return args[valueIndex];
    }

    return getFlagValueInternal(long) ?? getFlagValueInternal(short);
  }

  OptionalFlagResult getOptionalFlagValue(List<String> args) {
    OptionalFlagResult getOptionalFlagValueInternal(String? flag) {
      if (flag == null) return FlagNotPresent();
      final index = args.indexOf(flag).toNullableIndexOfResult();
      if (index == null) return FlagNotPresent();
      args.removeAt(index);

      if (args.length > index) {
        final nextArg = args[index];
        if (!nextArg.startsWith('-')) {
          args.removeAt(index);
          return FlagPresent(nextArg);
        }
      }
      return FlagPresent(null);
    }

    OptionalFlagResult getOptionalShortFlagValueInternal() {
      if (short == null) return FlagNotPresent();
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
                if (!nextArg.startsWith('-')) {
                   args.removeAt(i);
                   return FlagPresent(nextArg);
                }
             }
             return FlagPresent(null);
          } else {
             args[i] = newArg;
             return FlagPresent(null); // The flag was combined (e.g., -av). No value supported for combined flags.
          }
        }
      }
      return FlagNotPresent();
    }

    final longResult = getOptionalFlagValueInternal(long);
    if (longResult is FlagPresent) return longResult;
    return getOptionalShortFlagValueInternal();
  }

  @override
  String toString() {
    return "${[short, long].nonNulls.join(", ")} - $description";
  }
}
