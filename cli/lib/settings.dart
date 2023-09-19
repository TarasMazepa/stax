import 'dart:io';

import 'package:stax/context_for_internal_command.dart';
import 'package:stax/file_path_dir_on_uri.dart';
import 'package:stax/shortcuts_for_internal_command_context.dart';

class Settings {
  static void load() {
    ContextForInternalCommand.silent()
        .getRepositoryRoot(workingDirectory: Platform.script.toFilePathDir());
  }
}
