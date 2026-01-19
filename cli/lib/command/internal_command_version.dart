import 'package:stax/command/internal_command.dart';
import 'package:stax/context/context.dart';

class InternalCommandVersion extends InternalCommand {
  static final version = const String.fromEnvironment(
    'version',
    defaultValue: '0.10.24',
  );

  InternalCommandVersion() : super('version', 'Version of stax');

  @override
  Future<void> run(List<String> args, Context context) async {
    context.printToConsole(version);
  }
}
