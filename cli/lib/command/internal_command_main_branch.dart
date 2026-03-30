import 'package:stax/command/internal_command.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_default_branch.dart';

class InternalCommandMainBranch extends InternalCommand {
  InternalCommandMainBranch()
    : super(
        'main-branch',
        'Shows which branch stax considers to be main.',
        type: InternalCommandType.hidden,
      );

  @override
  Future<void> run(final List<String> args, final Context context) async {
    final defaultBranch = await context.getDefaultBranch();
    if (defaultBranch != null) {
      context.printToConsole("Your default branch is '$defaultBranch'");
    }

    context.printParagraph('''
You can override the default branch for this repository using:
  stax settings set default_branch <branch_name>

Or globally for all repositories:
  stax settings set --global default_branch <branch_name>

If not overridden, stax uses the branch pointed to by <remote>/HEAD.
You can set this using git:
  git remote set-head <remote_name> -a
  # or
  git remote set-head <remote_name> <branch_name>''');
  }
}
