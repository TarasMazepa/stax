import 'dart:convert';

import 'package:stax/settings/setting.dart';
import 'package:stax/settings/settings.dart';

abstract class BaseListSetting<T> extends Setting<List<T>> {
  BaseListSetting(
    String name,
    List<T> defaultValue,
    Settings settings,
    String description,
    T? Function(String) fromStringItemConverter,
    String Function(T) toStringItemConverter,
  ) : super(
          name,
          defaultValue,
          settings,
          (String s) => (jsonDecode(s) as List).expand<T>(
            (element) {
              try {
                return switch (fromStringItemConverter(element)) {
                  null => [],
                  final parsed => [parsed],
                };
              } catch (_) {
                return [];
              }
            },
          ).toList(),
          (List<T> list) =>
              jsonEncode(list.map(toStringItemConverter).toList()),
          description,
        );

  void add(T item) {
    value = [...value, item];
  }

  void remove(T item) {
    value = value.where((e) => e != item).toList();
  }
}
