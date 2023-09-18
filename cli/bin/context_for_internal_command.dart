import 'package:stax/git.dart';

class ContextForInternalCommand {
  final List<String> args;
  final git = Git();

  ContextForInternalCommand(this.args);

  ContextForInternalCommand.empty() : this([]);
}
