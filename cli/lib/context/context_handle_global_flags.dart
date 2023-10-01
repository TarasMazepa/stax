import 'package:stax/context/context.dart';

extension ContextHandleGlobalFlags on Context {
  static final _silentFlag = "--silent";
  static final _loudFlag = "--loud";

  static Map<String, String> get flags => {
        _silentFlag: "Removes all output except user prompts.",
        _loudFlag: "Force all the output.",
      };

  Context handleGlobalFlags(List<String> args) {
    Context result = this;
    if (args.remove(_silentFlag)) {
      result = result.withSilence(true);
    }
    if (args.remove(_loudFlag)) {
      result = result.withForcedLoudness(true);
    }
    return result;
  }
}
