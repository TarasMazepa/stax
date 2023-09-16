import 'external_command.dart';

class Git {
  static final currentBranch =
      ExternalCommand.split("git branch --show-current");
  static final pull = ExternalCommand.split("git pull");
}
