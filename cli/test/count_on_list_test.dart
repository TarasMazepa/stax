import 'package:stax/count_on_list.dart';
import 'package:test/test.dart';

void main() {
  test('empty list', () {
    expect([].count(0), 0);
  });
  test('wrong item', () {
    expect([1].count(0), 0);
  });
  test('one item', () {
    expect([1].count(1), 1);
  });
  test('may items', () {
    expect([1, 2, 3, 4, 5, 6, 7, 8, 9, 1].count(1), 2);
  });
  [].where((element) => false).length;
}
