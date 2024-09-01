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
    return args.remove(short) || args.remove(long);
  }
}
