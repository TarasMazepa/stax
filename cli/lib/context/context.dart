import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:stax/context/context_git_get_repository_root.dart';
import 'package:stax/external_command/external_command.dart';
import 'package:stax/file/file_path_dir_on_uri.dart';
import 'package:stax/git/git.dart';
import 'package:stax/rebase/rebase_use_case.dart';
import 'package:stax/settings/base_settings.dart';
import 'package:stax/settings/repository_settings.dart';
import 'package:stax/settings/settings.dart';

class Context {
  final bool quiet;
  final String? workingDirectory;
  final bool verbose;
  final bool acceptAll;
  final bool declineAll;

  late final Git git = Git(this);
  late final Settings settings = Settings();
  late final RepositorySettings? repositorySettings = RepositorySettings.load(
    this,
    settings,
  );
  late final BaseSettings effectiveSettings = repositorySettings ?? settings;
  late final RebaseUseCase? rebaseUseCase = RebaseUseCase.create(this);

  RebaseUseCase get assertRebaseUseCase => rebaseUseCase!;

  Context.implicit() : this(false, null, false, false, false);

  Context(
    this.quiet,
    this.workingDirectory,
    this.verbose,
    this.acceptAll,
    this.declineAll,
  );

  ExternalCommand command(List<String> parts) {
    return ExternalCommand(parts, this);
  }

  Context withQuiet(bool quiet) {
    if (this.quiet == quiet) return this;
    return Context(quiet, workingDirectory, verbose, acceptAll, declineAll);
  }

  Context quietly() => withQuiet(true);

  Context withVerbose(bool verbose) {
    if (this.verbose == verbose) return this;
    return Context(quiet, workingDirectory, verbose, acceptAll, declineAll);
  }

  Context withWorkingDirectory(String? workingDirectory) {
    if (this.workingDirectory == workingDirectory) return this;
    return Context(quiet, workingDirectory, verbose, acceptAll, declineAll);
  }

  Context withScriptPathAsWorkingDirectory() {
    return withWorkingDirectory(Platform.script.toFilePathDir());
  }

  Context withRepositoryRootAsWorkingDirectory() {
    return withWorkingDirectory(getRepositoryRoot());
  }

  Context withAcceptingAll(bool acceptAll) {
    if (this.acceptAll == acceptAll) return this;
    return Context(quiet, workingDirectory, verbose, acceptAll, declineAll);
  }

  Context withDecliningAll(bool declineAll) {
    if (this.declineAll == declineAll) return this;
    return Context(quiet, workingDirectory, verbose, acceptAll, declineAll);
  }

  bool shouldBeQuiet() {
    return !verbose && quiet;
  }

  void printToConsole(Object? object) {
    if (shouldBeQuiet()) return;
    print(object);
  }

  void printParagraph(Object? object) {
    printToConsole('''

$object
''');
  }

  StreamIterator<String>? _stdinIterator;

  Future<String?> _readLineAsync() async {
    _stdinIterator ??= StreamIterator(
        systemEncoding.decoder.bind(stdin).transform(const LineSplitter()));
    if (await _stdinIterator!.moveNext()) {
      return _stdinIterator!.current;
    }
    return null;
  }

  Future<bool> commandLineContinueQuestion(String questionContext) async {
    if (declineAll) {
      printToConsole(
        "Automatically declining '$questionContext' as per user request.",
      );
      return false;
    }
    if (acceptAll) {
      printToConsole(
        "Automatically accepting '$questionContext' as per user request.",
      );
      return true;
    }
    final includeSpace =
        questionContext.isNotEmpty &&
        questionContext[questionContext.length - 1] != '\n';
    if (includeSpace) questionContext += ' ';

    for (var i = 0; i < 3; i++) {
      print('${questionContext}Continue y/N? ');
      final response = await _readLineAsync();
      switch (response) {
        case 'y' || 'Y':
          return true;
        case 'n' || 'N' || '' || null:
          return false;
        default:
          if (i < 2) {
            print("Inconclusive answer '$response', please type 'y' or 'n'.");
          } else {
            print("Inconclusive answer '$response', defaulting to 'n'.");
          }
      }
    }
    return false;
  }

  Future<String?> commandLineMultipleOptionsQuestion(
    String questionContext,
    List<({String key, String description})> options,
  ) async {
    if (declineAll) {
      printToConsole(
        "Automatically declining '$questionContext' as per user request.",
      );
      return null;
    }

    print(questionContext);
    for (final option in options) {
      print(' ${option.key} - ${option.description}');
    }

    print('Your choice: ');
    final response = (await _readLineAsync())?.trim();

    if (response == null || response.isEmpty) {
      return null;
    }

    for (final option in options) {
      if (equalsIgnoreAsciiCase(option.key, response)) {
        return option.key;
      }
    }

    print("Unknown option selected '$response'");

    return null;
  }
}
