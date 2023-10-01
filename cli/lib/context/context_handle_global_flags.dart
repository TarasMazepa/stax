import 'package:stax/context/context.dart';

extension ContextHandleGlobalFlags on Context {
  static final _silentFlag = "--silent";
  static final _loudFlag = "--loud";
  static final _acceptAllFlag = "--accept-all";
  static final _declineAllFlag = "--decline-all";

  static Map<String, String> get flags => {
        _silentFlag: "Removes all output except user prompts.",
        _loudFlag: "Force all the output.",
        _acceptAllFlag: "Accept all the user prompts automatically.",
        _declineAllFlag: "Decline all the user prompts automatically.",
      };

  Context handleGlobalFlags(List<String> args) {
    Context result = this;
    if (args.remove(_silentFlag)) {
      result = result.withSilence(true);
    }
    if (args.remove(_loudFlag)) {
      result = result.withForcedLoudness(true);
    }
    if (args.remove(_acceptAllFlag)) {
      result = result.withAcceptingAll(true);
    }
    if (args.remove(_declineAllFlag)) {
      result = result.withDecliningAll(true);
    }
    return result;
  }
}
