import 'dart:io';
import 'package:path/path.dart' as path;

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
  Future<void> run(List<String> args, Context context) async {
    for (final commandText in CommitTreeForTestCase.fromCompacted(
      args[0],
    ).getTargetCommands()) {
      ExternalCommand command = context.command(commandText.split(' '));
      if (command.parts[0] == 'stax') {
        await mainFunctionReference(command.parts.sublist(1));
      } else if (command.parts[0] == 'echo' && command.parts.contains('>')) {
        final redirectIndex = command.parts.indexOf('>');
        if (redirectIndex + 1 < command.parts.length) {
          final content = command.parts.sublist(1, redirectIndex).join(' ');
          final filename = command.parts[redirectIndex + 1];
          final cleanContent =
              content.length >= 2 &&
                  content.startsWith("'") &&
                  content.endsWith("'")
              ? content.substring(1, content.length - 1)
              : content;
          final workingDirectory = context.workingDirectory;
          final file = File(
            workingDirectory != null
                ? path.join(workingDirectory, filename)
                : filename,
          );
          file.writeAsStringSync('$cleanContent\n');
        }
      } else {
        command.runSync().printNotEmptyResultFields();
      }
    }
  }
}
