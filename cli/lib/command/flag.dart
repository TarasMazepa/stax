class Flag {
  final String? short;
  final String? long;
  final String description;

  Flag({this.short, this.long, required this.description})
      : assert(
          short != null || long != null,
          "Either short or long should be not null",
        ),
        assert(
          short == null || (short.startsWith("-") && short.length == 2),
          "Short should have format '-x', where x is a single symbol",
        ),
        assert(
          long == null || (long.startsWith("--") && long.length > 2),
          "Long should have format '--xxx', where xxx is a long name of the flag",
        );

  bool hasFlag(List<String> args) {
    return switch (0) {
      0 when long != null && args.remove(long) => true,
      0 when short != null && args.remove(short) => true,
      0
          when short != null &&
              args.any(
                (element) => switch (0) {
                  0 when element.length < 2 => false,
                  0 when element[0] != "-" => false,
                  0 when element[1] == "-" => false,
                  _ => element.contains(short![1]),
                },
              ) =>
        true,
      _ => false,
    };
  }
}
