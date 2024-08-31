class Flag {
  final String? short;
  final String? long;
  final String description;

  Flag(this.short, this.long, this.description)
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
}

extension MapToFlags on Map<String, String> {
  List<Flag> toFlags() {
    return entries
        .map(
          (e) => Flag(
            e.key.startsWith("--") ? null : e.key,
            e.key.startsWith("--") ? e.key : null,
            e.value,
          ),
        )
        .toList();
  }
}
