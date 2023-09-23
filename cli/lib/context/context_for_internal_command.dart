import 'package:stax/context/context.dart';
import 'package:stax/git/git.dart';

class ContextForInternalCommand {
  final List<String> args;
  final Context context;

  Git get git => context.git;

  ContextForInternalCommand(this.args, this.context);

  ContextForInternalCommand.empty() : this([], Context.loud());

  ContextForInternalCommand.silent() : this([], Context.silent());
}
