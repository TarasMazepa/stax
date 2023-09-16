import 'external_command.dart';

class Git {
  static final branchCurrent =
      ExternalCommand.split("git branch --show-current");
  static final branchDelete = ExternalCommand.split("git branch -D");
  static final branches = ExternalCommand.split("git branch -vv");
  static final fetch = ExternalCommand.split("git fetch -p");
  static final pull = ExternalCommand.split("git pull");
}
