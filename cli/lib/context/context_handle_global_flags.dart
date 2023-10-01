import 'package:stax/context/context.dart';

extension ContextHandleGlobalFlags on Context {
  static final _silentFlag = "--silent";

  static Map<String, String> get flags => {
        _silentFlag: "Removes all output except user prompts.",
      };

  Context handleGlobalFlags(List<String> args) {
    Context result = this;
    if (args.remove(_silentFlag)) {
      result = result.withSilence(true);
    }
    return result;
  }
}
