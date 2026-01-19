import 'dart:io';

import 'package:stax/external_command/extended_process_result.dart';
import 'package:stax/external_command/external_command.dart';

extension OnProcessResult on ProcessResult {
  ExtendedProcessResult extend(ExternalCommand externalCommand) {
    return ExtendedProcessResult(this, externalCommand.context);
  }
}
