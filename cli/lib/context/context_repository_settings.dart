import 'package:stax/context/context.dart';
import 'package:stax/settings/repository_settings.dart';

extension ContextRepositorySettings on Context {
  static RepositorySettings? _repositorySettings;
  static bool _repositorySettingsLoaded = false;

  RepositorySettings? get repositorySettings {
    if (!_repositorySettingsLoaded) {
      _repositorySettings = RepositorySettings.load(this);
      _repositorySettingsLoaded = true;
    }
    return _repositorySettings;
  }
}
