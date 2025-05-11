import 'dart:io';
import 'package:stax/command/flag.dart';
import 'package:stax/daemon/commands/base_command.dart';

class WatchCommand extends DaemonCommand {
  static final pathsFlag = Flag(
    long: '--paths',
    description: 'Comma-separated list of paths to watch',
  );

  WatchCommand()
    : super('watch', 'Watch specified paths for changes', flags: [pathsFlag]);

  @override
  Future<void> execute(Socket client, List<String> args) async {
    print(args);
    final pathsValue = pathsFlag.getFlagValue(args);

    if (pathsValue == null || pathsValue.isEmpty) {
      client.write('ERROR: --paths flag is required\n');
      return;
    }

    final paths = pathsValue.split(',').map((p) => p.trim()).toList();
    if (paths.isEmpty) {
      client.write('ERROR: No valid paths provided\n');
      return;
    }

    for (final path in paths) {
      final dir = Directory(path);
      if (!dir.existsSync()) {
        client.write('ERROR: Directory does not exist: $path\n');
        continue;
      }

      dir.watch(events: FileSystemEvent.all).listen((event) {
        client.write('Change detected: ${event.path} (${event.type})\n');
      });

      client.write('Watching directory: $path\n');
    }
  }
}
