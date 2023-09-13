abstract class Command {
  final String name;
  final String description;

  const Command(this.name, this.description);

  void run(final List<String> args);
}
