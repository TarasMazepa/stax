import 'package:stax/context/context.dart';

import 'internal_command.dart';

class InternalCommandVersion extends InternalCommand {
  static final version = const String.fromEnvironment(
    'version',
    defaultValue: '0.10.14',
  );

  InternalCommandVersion() : super('version', 'Version of stax');

  @override
  void run(List<String> args, Context context) {
    context.printToConsole(version);
  }
}
