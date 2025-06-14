import 'dart:io';

void main() {
  // Create CSV file
  final file = File('command_permutations.csv');
  final sink = file.openWrite();

  // Write CSV header
  sink.writeln('command,flags,arguments,description,full_command');

  final staxCommands = [
    {
      'name': 'about',
      'flags': [],
      'description': 'Shows information about the stax.',
    },
    {
      'name': 'amend',
      'flags': ['-A', '-a', '-b', '-m', '-r', '-u'],
      'description': 'Amends and pushes changes.',
    },
    {
      'name': 'commit',
      'flags': ['-A', '-a', '-b', '-i', '-p', '-u'],
      'args': [
        {
          'required': true,
          'description': 'Commit message',
          'value': 'commit-message',
          'type': 'string',
        },
        {
          'required': false,
          'description': 'Branch name',
          'value': 'branch-name',
          'type': 'string',
        },
      ],
      'description': 'Creates a branch, commits, and pushes it to remote.',
    },
    {
      'name': 'delete',
      'flags': ['-f', '-s'],
      'description': 'Deletes local branches with gone remotes.',
    },
    {
      'name': 'doctor',
      'flags': [],
      'description': 'Helps to ensure that stax has everything to be used.',
    },
    {
      'name': 'get',
      'args': [
        {
          'required': false,
          'description': 'Name of the remote ref',
          'value': 'branch-name',
          'type': 'string',
        },
      ],
      'description': '(Re)Checkout specified branch and all its children',
    },
    {
      'name': 'help',
      'flags': ['-a'],
      'args': [
        {
          'required': false,
          'description': 'Name of the command to learn about',
          'value': 'command-name',
          'type': 'string',
        },
      ],
      'description': 'List of available commands.',
    },
    {
      'name': 'log',
      'flags': ['-a', '-d'],
      'description': 'Shows a tree of all branches.',
    },
    {
      'name': 'move',
      'args': [
        {
          'required': true,
          'description': 'Direction (up, down, top, bottom, head)',
          'value': 'direction',
          'type': 'string',
        },
        {
          'required': false,
          'description': 'Child index for up/top',
          'value': 'index',
          'type': 'string',
        },
      ],
      'description': 'Allows you to move around log tree.',
    },
    {
      'name': 'pull',
      'flags': ['-f', '-s'],
      'args': [
        {
          'required': false,
          'description': 'Target branch',
          'value': 'branch-name',
          'type': 'string',
        },
      ],
      'description':
          'Switching to main branch, pull all the changes, deleting gone branches and switching to original branch.',
    },
    {
      'name': 'pull-request',
      'flags': [],
      'description': 'Creates a pull request.',
    },
    {
      'name': 'rebase',
      'flags': ['-a', '-b', '-c', '-m'],
      'args': [
        {
          'required': false,
          'description': 'Target branch',
          'value': 'branch-name',
          'type': 'string',
        },
      ],
      'description': 'rebase tree of branches on top of main',
    },
    {
      'name': 'settings',
      'flags': ['-g'],
      'args': [
        {
          'required': true,
          'description': 'Subcommand (add, clear, remove, set, show)',
          'value': 'subcommand',
          'type': 'string',
        },
        {
          'required': false,
          'description': 'Setting name',
          'value': 'setting-name',
          'type': 'string',
        },
        {
          'required': false,
          'description': 'Setting value',
          'value': 'setting-value',
          'type': 'string',
        },
      ],
      'description': 'View or modify stax settings',
    },
    {'name': 'version', 'flags': [], 'description': 'Version of stax'},
  ];

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

        // Escape any commas in the fields
        final escapedFlags = flagString.replaceAll(',', ';');
        final escapedArgs = argString.replaceAll(',', ';');
        final escapedDesc = command['description'].toString().replaceAll(
          ',',
          ';',
        );
        final escapedFullCommand = fullCommand.replaceAll(',', ';');

        // Write to CSV
        sink.writeln(
          'stax $commandName,$escapedFlags,$escapedArgs,$escapedDesc,$escapedFullCommand',
        );
      }
    }
  }

  // Close the file
  sink.close();
  print('Command permutations written to command_permutations.csv');
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
