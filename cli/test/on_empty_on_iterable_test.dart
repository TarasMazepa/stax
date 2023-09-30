import 'package:stax/on_empty_on_iterable.dart';
import 'package:test/test.dart';

void main() {
  test('onEmpty executed', () {
    var executed = false;
    [].onEmpty(() {
      executed = true;
    }).firstOrNull;
    expect(executed, true);
  });
  test('onEmpty not executed', () {
    var executed = false;
    [1].onEmpty(() {
      executed = true;
    }).firstOrNull;
    expect(executed, false);
  });
}
