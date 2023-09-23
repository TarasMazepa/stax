import 'package:stax/context/context.dart';
import 'package:stax/git.dart';

class ContextForInternalCommand {
  final List<String> args;
  final Context context;

  late final git = Git(context);

  ContextForInternalCommand(this.args, this.context);

  ContextForInternalCommand.empty() : this([], Context.loud());

  ContextForInternalCommand.silent() : this([], Context.silent());
}
