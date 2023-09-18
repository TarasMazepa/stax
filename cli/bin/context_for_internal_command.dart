import 'package:stax/git.dart';

class ContextForInternalCommand {
  final List<String> args;
  final bool silent;

  late final git = Git(silent: silent);

  ContextForInternalCommand(this.args, {this.silent = false});

  ContextForInternalCommand.empty() : this([]);
}
