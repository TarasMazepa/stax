import 'package:stax/context/context.dart';

import 'internal_command.dart';

class InternalCommandVersion extends InternalCommand {
  InternalCommandVersion()
      : super(
          "version",
          "Version of stax",
        );

  @override
  void run(List<String> args, Context context) {
    context.printToConsole(
        const String.fromEnvironment("version", defaultValue: "unknown"));
  }
}
