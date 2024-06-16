import 'package:stax/context/context.dart';
import 'package:stax/string_empty_to_null.dart';
import 'internal_command.dart';

class InternalCommandDoctor extends InternalCommand {
  InternalCommandDoctor()
      : super("doctor", "Helps to ensure that stax has everything to be used.");

  @override
  void run(final List<String> args, Context context) {
    String boolToCheckmark(bool value) => value ? "V" : "X";

    final userName = context
        .withSilence(true)
        .git
        .configGet
        .arg("user.name")
        .announce("Checking for users name.")
        .runSync()
        .stdout
        .toString()
        .trim()
        .emptyToNull();

    final hasUserName = userName != null;
    context.printToConsole(
        """[${boolToCheckmark(hasUserName)}] git config --get user.name # $userName""");

    if (!hasUserName) {
      context.printToConsole("""    X Set your git user name using:""");
      context.printToConsole(
          """      git config --global user.name "<your preferred name>" """);
    }

    final userEmail = context
        .withSilence(true)
        .git
        .configGet
        .arg("user.email")
        .announce("Checking for users email.")
        .runSync()
        .stdout
        .toString()
        .trim()
        .emptyToNull();

    final hasUserEmail = userEmail != null;
    context.printToConsole(
        """[${boolToCheckmark(hasUserEmail)}] git config --get user.email # $userEmail""");

    if (!hasUserEmail) {
      context.printToConsole("""    X Set your git user email using:""");
      context.printToConsole(
          """      git config --global user.email "<your preferred email>" """);
    }

    final autoSetupRemote = context
        .withSilence(true)
        .git
        .configGet
        .arg("push.autoSetupRemote")
        .runSync()
        .stdout
        .toString()
        .trim()
        .emptyToNull();

    final hasAutoSetupRemote = autoSetupRemote == "true";
    context.printToConsole(
        """[${boolToCheckmark(hasAutoSetupRemote)}] git config --get push.autoSetupRemote # $hasAutoSetupRemote""");

    if (!hasUserEmail) {
      context.printToConsole("""    X Set git push.autoSetupRemote using:""");
      context.printToConsole(
          """      git config --global push.autoSetupRemote true """);
    }
  }
}
