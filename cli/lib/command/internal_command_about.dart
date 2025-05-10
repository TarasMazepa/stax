import 'package:stax/command/internal_command.dart';
import 'package:stax/context/context.dart';

class InternalCommandAbout extends InternalCommand {
  InternalCommandAbout() : super('about', 'Shows information about the stax.');

  @override
  void run(final List<String> args, Context context) {
    context.printToConsole('stax - A Git workflow tool');
    context.printToConsole('');
    context.printToConsole(
      'stax is a command-line tool that helps you manage your Git workflow more efficiently.',
    );
    context.printToConsole(
      'It provides a set of commands to simplify common Git operations and maintain a clean repository structure.',
    );
    context.printToConsole('');
    context.printToConsole(
      'For more information, visit: https://staxforgit.com/',
    );
  }
}
