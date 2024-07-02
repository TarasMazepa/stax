import 'package:collection/collection.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_all_branches.dart';
import 'package:stax/context/context_git_get_default_branch.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';
import 'package:stax/context/context_git_log_one_line_no_decorate_single_branch.dart';
import 'package:stax/log/decorated/map_to_string_on_list_of_decorated_log_lines.dart';
import 'package:stax/log/decorated/decorated_log_line.dart';
import 'package:stax/log/decorated/decorated_log_line_producer.dart';
import 'package:stax/log/decorated/decorated_log_line_producer_adapter_for_log_tree_node.dart';
import 'package:stax/log/log_tree_node.dart';
import 'package:stax/log/parsed_log_line.dart';
import 'package:stax/nullable_index_of.dart';

import 'internal_command.dart';

class InternalCommandLog extends InternalCommand {
  static final String defaultBranchFlag = "--default-branch";

  InternalCommandLog()
      : super("log", "Builds a tree of all branches.",
            flags: {defaultBranchFlag: "assume different default branch"});

  @override
  void run(List<String> args, Context context) {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }
    context = context.withSilence(true);

    print(materializeDecoratedLogLines(context.gitLogAll().collapse(),
            DecoratedLogLineProducerAdapterForGitLogAllNode())
        .join("\n"));
  }
}
