import 'package:stax/settings/key_value_store.dart';

class Setting<T> {
  final String name;
  final String description;
  final T _defaultValue;
  final KeyValueStore _keyValueStore;
  final T Function(String) _fromStringConverter;
  final String Function(T) _toStringConverter;

  Setting(
    this.name,
    this._defaultValue,
    this._keyValueStore,
    this._fromStringConverter,
    this._toStringConverter,
    this.description,
  );

  String get rawValue => switch (_keyValueStore[name]) {
    null => _toStringConverter(_defaultValue),
    final raw => raw,
  };

  T get value => switch (_keyValueStore[name]) {
    null => _defaultValue,
    final raw => _fromStringConverter(raw),
  };

  set value(T newValue) {
    _keyValueStore[name] = _toStringConverter(newValue);
    _keyValueStore.save();
  }

  void clear() {
    _keyValueStore[name] = null;
    _keyValueStore.save();
  }
}
