import 'dart:convert';

import 'package:stax/settings/setting.dart';
import 'package:stax/settings/settings.dart';

abstract class BaseListSetting<T> extends Setting<List<T>> {
  BaseListSetting(
    String name,
    List<T> defaultValue,
    Settings settings,
    String description,
    T? Function(String) fromString,
    String Function(T) toString,
  ) : super(
          name,
          defaultValue,
          settings,
          (String s) => (jsonDecode(s) as List<String>).expand<T>(
            (element) {
              try {
                return switch (fromString(element)) {
                  null => [],
                  final converted => [converted],
                };
              } catch (_) {
                return [];
              }
            },
          ).toList(),
          (List<T> list) => jsonEncode(list.map(toString).toList()),
          description,
        );

  void add(T item) {
    value = [...value, item];
  }

  void remove(T item) {
    value = value.where((e) => e != item).toList();
  }
}
