abstract class InternalCommand {
  final String name;
  final String description;

  const InternalCommand(this.name, this.description);

  void run(final List<String> args);
}
