import 'package:stax/context/context.dart';
import 'package:stax/string_empty_to_null.dart';
import 'internal_command.dart';

class InternalCommandSetup extends InternalCommand {
  InternalCommandSetup()
      : super("setup", "setup user information name, email.");

  @override
  void run(final List<String> args, Context context) {
    final getName = context.git.configGetUser
        .announce("Checking for users name.")
        .runSync()
        .stdout
        .toString()
        .trim()
        .emptyToNull();

    if (getName == null) {
      final name =
          context.commandLineInputPrompt("Please enter your username:");

      context.git.config
          .args(["--global", "user.name", name])
          .announce("Setting user.name to $name")
          .runSync()
          .printNotEmptyResultFields();
    }

    final getEmail = context.git.configGetUser
        .announce("Checking for users email.")
        .runSync()
        .stdout
        .toString()
        .trim()
        .emptyToNull();

    if (getEmail == null) {
      final email = context.commandLineInputPrompt("Please enter your email:");

      context.git.config
          .args(["--global", "user.email", email])
          .announce("Setting user.email to $email")
          .runSync()
          .printNotEmptyResultFields();
    }

    final getAutoSetupRemote = context.git.configGetAutoSetupRemote
        .runSync()
        .stdout
        .toString()
        .trim()
        .emptyToNull();

    if (getAutoSetupRemote == null || getAutoSetupRemote == "false") {
      context.git.config
          .args(["--global", "push.autoSetupRemote", "true"])
          .announce("Setting push.autoSetupRemote to true")
          .runSync()
          .printNotEmptyResultFields();
    }
  }
}
