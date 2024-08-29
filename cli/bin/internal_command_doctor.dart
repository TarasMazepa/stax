import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_default_branch.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/string_empty_to_null.dart';

import 'internal_command.dart';

class InternalCommandDoctor extends InternalCommand {
  InternalCommandDoctor()
      : super("doctor", "Helps to ensure that stax has everything to be used.");

  @override
  void run(final List<String> args, Context context) {
    String boolToCheckmark(bool value) => value ? "V" : "X";

    {
      final userName = context
          .withSilence(true)
          .git
          .configGet
          .arg("user.name")
          .announce("Checking for users name.")
          .runSync()
          .printNotEmptyResultFields()
          .stdout
          .toString()
          .trim()
          .emptyToNull();

      final hasUserName = userName != null;
      context.printToConsole(
        """[${boolToCheckmark(hasUserName)}] git config --get user.name # $userName""",
      );

      if (!hasUserName) {
        context.printToConsole("""    X Set your git user name using:""");
        context.printToConsole(
          """      git config --global user.name "<your preferred name>" """,
        );
      }
    }

    {
      final userEmail = context
          .withSilence(true)
          .git
          .configGet
          .arg("user.email")
          .announce("Checking for users email.")
          .runSync()
          .printNotEmptyResultFields()
          .stdout
          .toString()
          .trim()
          .emptyToNull();

      final hasUserEmail = userEmail != null;
      context.printToConsole(
        """[${boolToCheckmark(hasUserEmail)}] git config --get user.email # $userEmail""",
      );

      if (!hasUserEmail) {
        context.printToConsole("""    X Set your git user email using:""");
        context.printToConsole(
          """      git config --global user.email "<your preferred email>" """,
        );
      }
    }

    {
      final autoSetupRemote = context
          .withSilence(true)
          .git
          .configGet
          .arg("push.autoSetupRemote")
          .announce("Checking if push.autoSetupRemote set in git config.")
          .runSync()
          .printNotEmptyResultFields()
          .stdout
          .toString()
          .trim()
          .emptyToNull();

      final hasAutoSetupRemote = autoSetupRemote == "true";
      context.printToConsole(
        """[${boolToCheckmark(hasAutoSetupRemote)}] git config --get push.autoSetupRemote # $hasAutoSetupRemote""",
      );

      if (!hasAutoSetupRemote) {
        context.printToConsole("""    X Set git push.autoSetupRemote using:""");
        context.printToConsole(
          """      git config --global push.autoSetupRemote true """,
        );
      }
    }

    if (context.isInsideWorkTree()) {
      final remotes = context
          .withSilence(true)
          .git
          .remote
          .announce("Checking if git repository has remote.")
          .runSync()
          .printNotEmptyResultFields()
          .stdout
          .toString()
          .trim()
          .split("\n")
          .where((x) => x.isNotEmpty)
          .toList();
      final hasRemote = remotes.isNotEmpty;
      context.printToConsole(
        """[${boolToCheckmark(hasRemote)}] git remote # ${hasRemote ? "remote(s): ${remotes.join(", ")}" : "no remotes"}""",
      );

      if (!hasRemote) {
        context.printToConsole("""    X Set at least one remote using:""");
        context.printToConsole(
          """      git remote add origin <url to git repository>""",
        );
      }
    }

    if (context.isInsideWorkTree()) {
      String? defaultBranch = context.withSilence(true).getDefaultBranch();
      String remote =
          ContextGitGetDefaultBranch.remotes?.firstOrNull ?? "<remote>";
      context.printToConsole(
        """[${boolToCheckmark(defaultBranch != null)}] git rev-parse --abbrev-ref $remote/HEAD # ${defaultBranch ?? "not found"}""",
      );

      if (defaultBranch == null) {
        context.printToConsole("""    X Set default remote branch using:""");
        context.printToConsole(
          """      git fetch -p ; git remote set-head $remote -a""",
        );
      }
    }
  }
}
