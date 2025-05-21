import 'dart:io';

import 'package:stax/command/internal_command.dart';
import 'package:stax/command/main_function_reference.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/commit_tree_for_test_case.dart';
import 'package:stax/context/context.dart';
import 'package:stax/external_command/external_command.dart';

class InternalCommandLogTestCase extends InternalCommand {
  InternalCommandLogTestCase()
    : super(
        'log-test-case',
        'shows test case for log command',
        type: InternalCommandType.hidden,
      );

  @override
  void run(List<String> args, Context context) {
    for (final commandText
        in CommitTreeForTestCase.fromCompacted(args[0]).getTargetCommands()) {
      ExternalCommand command = context.command(commandText.split(' '));
      if (command.parts[0] == 'stax') {
        mainFunctionReference(command.parts.sublist(1));
      } else if (Platform.isWindows && command.parts[0] == 'echo') {
        context
            .command(['powershell', '-c', ...command.parts])
            .runSync()
            .printNotEmptyResultFields();
      } else if (command.parts[0] == 'echo') {
        context
            .command(['touch', ...command.parts.sublist(1)])
            .runSync()
            .printNotEmptyResultFields();
      } else {
        command.runSync().printNotEmptyResultFields();
      }
    }
  }
}
