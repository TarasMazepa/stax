import 'dart:io';
import 'dart:convert';
import 'package:stax/command/internal_commands.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/command/flag.dart';

void main() {
  // Create JSON file

  // List to store all command permutations
  final List<Map<String, dynamic>> permutations = [];

  final staxCommands = internalCommands
      .where((cmd) => cmd.type == InternalCommandType.public)
      .map(
        (cmd) => {
          'name': cmd.name,
          'flags': cmd.flags?.map((f) => f.short).toList() ?? [],
          'description': cmd.description,
          'args':
              cmd.arguments?.entries
                  .map(
                    (e) => {
                      'required': e.key.startsWith('arg'),
                      'description': e.value,
                      'value': e.key,
                      'type': 'string',
                    },
                  )
                  .toList() ??
              [],
        },
      )
      .toList();

  for (final command in staxCommands) {
    final commandName = command['name'];
    final flags = (command['flags'] as List<dynamic>? ?? []).cast<String>();
    final args = (command['args'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final combinations = powerSet(flags);

    // Separate required and optional arguments
    final requiredArgs = args.where((arg) => arg['required'] == true).toList();
    final optionalArgs = args.where((arg) => arg['required'] != true).toList();

    // Generate all combinations of optional arguments (present or absent)
    final optionalArgCombos = powerSet(optionalArgs);

    for (final combo in combinations) {
      // Sort flags to ensure consistent order in output
      final sortedFlags = combo.toList()..sort();
      final flagString = sortedFlags.join(' ');

      for (final optCombo in optionalArgCombos) {
        // Build argument string: required + this optional combo
        final allArgs = [...requiredArgs, ...optCombo];
        final argString = allArgs.isNotEmpty
            ? allArgs
                  .map((a) {
                    final value = a['value'];
                    final type = a['type'];
                    if (type == 'string') {
                      return '"$value"';
                    } else {
                      return value;
                    }
                  })
                  .join(' ')
            : '';

        // Create full command string
        final fullCommand =
            'stax $commandName'
            '${flagString.isNotEmpty ? ' ' + flagString : ''}'
            '${argString.isNotEmpty ? ' ' + argString : ''}';

        // Add permutation to list
        permutations.add({
          'command': 'stax $commandName',
          'flags': sortedFlags,
          'arguments': allArgs.map((a) => a['value'] as String).toList(),
          'description': command['description'],
          'full_command': fullCommand,
        });
      }
    }
  }

  // Write JSON to file with pretty printing
  print(JsonEncoder.withIndent('  ').convert(permutations));

  // Close the file
  // sink.close();
  print('Exited');
}

/// Returns the power set (all subsets) of the given list.
List<List<T>> powerSet<T>(List<T> list) {
  int n = list.length;
  List<List<T>> result = [];

  for (int i = 0; i < (1 << n); i++) {
    List<T> subset = [];
    for (int j = 0; j < n; j++) {
      if ((i & (1 << j)) != 0) {
        subset.add(list[j]);
      }
    }
    result.add(subset);
  }
  return result;
}
