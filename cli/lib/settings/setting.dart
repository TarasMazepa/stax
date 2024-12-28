import 'package:stax/settings/settings.dart';

class Setting<T> {
  final String _name;
  final T _defaultValue;
  final Settings _settings;
  final T Function(String) _fromStringConverter;
  final String Function(T) _toStringConverter;

  Setting(
    this._name,
    this._defaultValue,
    this._settings,
    this._fromStringConverter,
    this._toStringConverter,
  );

  T get() {
    final raw = _settings[_name];
    if (raw == null) return _defaultValue;
    return _fromStringConverter(raw);
  }

  void set(T t) {
    _settings[_name] = _toStringConverter(t);
    _settings.save();
  }
}
