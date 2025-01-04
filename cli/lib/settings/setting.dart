import 'package:stax/settings/settings.dart';

class Setting<T> {
  final String name;
  final String description;
  final T _defaultValue;
  final Settings _settings;
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

  T get value => switch (_settings[name]) {
        null => _defaultValue,
        final raw => _fromStringConverter(raw)
      };

  set value(T newValue) {
    _settings[name] = _toStringConverter(newValue);
    _settings.save();
  }

  T get value => get();
}
