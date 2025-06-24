import 'package:stax/command/flag.dart';
import 'package:stax/context/context.dart';

extension ContextHandleGlobalFlags on Context {
  static final quietFlag = Flag(
    short: '-q',
    long: '--quiet',
    description: 'Removes all output except user prompts.',
  );
  static final loudFlag = Flag(
    long: '--loud',
    description: 'Force all the output.',
  );
  static final acceptAllFlag = Flag(
    long: '--accept-all',
    description: 'Accept all the user prompts automatically.',
  );
  static final declineAllFlag = Flag(
    long: '--decline-all',
    description: 'Decline all the user prompts automatically.',
  );
  static final helpFlag = Flag(
    short: '-h',
    long: '--help',
    description: 'Shows help documentation for the command',
  );

  static final List<Flag> flags = [
    quietFlag,
    loudFlag,
    acceptAllFlag,
    declineAllFlag,
    helpFlag,
  ];

  Context handleGlobalFlags(List<String> args) {
    return withSilence(quietFlag.hasFlag(args))
        .withForcedLoudness(loudFlag.hasFlag(args))
        .withAcceptingAll(acceptAllFlag.hasFlag(args))
        .withDecliningAll(declineAllFlag.hasFlag(args));
  }

  bool hasHelpFlag(List<String> args) {
    return helpFlag.hasFlag(args);
  }
}
