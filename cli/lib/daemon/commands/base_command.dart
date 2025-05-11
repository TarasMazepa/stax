import 'dart:io';
import 'package:stax/command/flag.dart';

abstract class DaemonCommand {
  final String name;
  final String description;
  final List<Flag> flags;

  DaemonCommand(this.name, this.description, {List<Flag>? flags})
    : flags = flags ?? [];

  Future<void> execute(Socket client, List<String> args);
}
