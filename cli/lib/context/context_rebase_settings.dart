import 'package:stax/context/context.dart';
import 'package:stax/rebase/rebase_settings.dart';

extension ContextRebaseSettings on Context {
  static RebaseSettings? _rebaseSettings;
  static bool _rebaseSettingsLoaded = false;

  RebaseSettings? get rebaseSettings {
    if (!_rebaseSettingsLoaded) {
      _rebaseSettings = RebaseSettings.load(this);
      _rebaseSettingsLoaded = true;
    }
    return _rebaseSettings;
  }
}
