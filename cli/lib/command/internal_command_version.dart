import 'package:stax/command/internal_command.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';

class InternalCommandVersion extends InternalCommand {
  static final version = const String.fromEnvironment(
    'version',
    defaultValue: '0.11.1',
  );

  InternalCommandVersion()
    : super('version', 'Version of stax', type: InternalCommandType.hidden);

  @override
  Future<void> run(List<String> args, Context context) async {
    context.printToConsole(version);
  }
}
