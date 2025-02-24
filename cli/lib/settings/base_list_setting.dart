import 'dart:convert';

import 'package:stax/settings/base_settings.dart';
import 'package:stax/settings/setting.dart';

abstract class BaseListSetting<T> extends Setting<List<T>> {
  T? Function(String) itemFromString;

  BaseListSetting(
    String name,
    List<T> defaultValue,
    BaseSettings settings,
    String description,
    this.itemFromString,
    String Function(T) itemToString,
  ) : super(
          name,
          defaultValue,
          settings,
          (String s) => (jsonDecode(s) as List<dynamic>)
              .map((element) => element.toString())
              .expand<T>(
            (element) {
              try {
                return switch (itemFromString(element)) {
                  null => [],
                  final converted => [converted],
                };
              } catch (_) {
                return [];
              }
            },
          ).toList(),
          (List<T> list) => jsonEncode(list.map(itemToString).toList()),
          description,
        );

  void add(T item) {
    value = [...value, item];
  }

  void remove(T item) {
    value = value.where((e) => e != item).toList();
  }
}
