import 'package:stax/settings/base_settings.dart';

class Setting<T> {
  final String name;
  final String description;
  final T _defaultValue;
  final BaseSettings _settings;
  final T Function(String) _fromStringConverter;
  final String Function(T) _toStringConverter;

  Setting(
    this.name,
    this._defaultValue,
    this._settings,
    this._fromStringConverter,
    this._toStringConverter,
    this.description,
  );

  String get rawValue => switch (_settings[name]) {
        null => _toStringConverter(_defaultValue),
        final raw => raw,
      };

  T get value => switch (_settings[name]) {
        null => _defaultValue,
        final raw => _fromStringConverter(raw)
      };

  set value(T newValue) {
    _settings[name] = _toStringConverter(newValue);
    _settings.save();
  }

  void clear() {
    _settings[name] = null;
    _settings.save();
  }
}
