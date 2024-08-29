import 'package:stax/int_range.dart';
import 'package:test/test.dart';

void main() {
  // Closed
  test('[0,10] contains 0', () {
    expect(IntRange.closed(0, 10).contains(0), true);
  });
  test('[0,10] contains -1', () {
    expect(IntRange.closed(0, 10).contains(-1), false);
  });
  test('[0,10] contains 1', () {
    expect(IntRange.closed(0, 10).contains(1), true);
  });
  test('[0,10] contains 9', () {
    expect(IntRange.closed(0, 10).contains(9), true);
  });
  test('[0,10] contains 10', () {
    expect(IntRange.closed(0, 10).contains(10), true);
  });
  test('[0,10] contains 11', () {
    expect(IntRange.closed(0, 10).contains(11), false);
  });
  // Closed open
  test('[0,10) contains 0', () {
    expect(IntRange.closedOpen(0, 10).contains(0), true);
  });
  test('[0,10) contains -1', () {
    expect(IntRange.closedOpen(0, 10).contains(-1), false);
  });
  test('[0,10) contains 1', () {
    expect(IntRange.closedOpen(0, 10).contains(1), true);
  });
  test('[0,10) contains 9', () {
    expect(IntRange.closedOpen(0, 10).contains(9), true);
  });
  test('[0,10) contains 10', () {
    expect(IntRange.closedOpen(0, 10).contains(10), false);
  });
  test('[0,10) contains 11', () {
    expect(IntRange.closedOpen(0, 10).contains(11), false);
  });
  // Open closed
  test('(0,10] contains 0', () {
    expect(IntRange.openClosed(0, 10).contains(0), false);
  });
  test('(0,10] contains -1', () {
    expect(IntRange.openClosed(0, 10).contains(-1), false);
  });
  test('(0,10] contains 1', () {
    expect(IntRange.openClosed(0, 10).contains(1), true);
  });
  test('[0,10] contains 9', () {
    expect(IntRange.closed(0, 10).contains(9), true);
  });
  test('[0,10] contains 10', () {
    expect(IntRange.closed(0, 10).contains(10), true);
  });
  test('[0,10] contains 11', () {
    expect(IntRange.closed(0, 10).contains(11), false);
  });
  // Open
  test('(0,10) contains 0', () {
    expect(IntRange.open(0, 10).contains(0), false);
  });
  test('(0,10) contains -1', () {
    expect(IntRange.open(0, 10).contains(-1), false);
  });
  test('(0,10) contains 1', () {
    expect(IntRange.open(0, 10).contains(1), true);
  });
  test('(0,10) contains 9', () {
    expect(IntRange.open(0, 10).contains(9), true);
  });
  test('(0,10) contains 10', () {
    expect(IntRange.open(0, 10).contains(10), false);
  });
  test('(0,10) contains 11', () {
    expect(IntRange.open(0, 10).contains(11), false);
  });
  // Singleton
  test('[0] contains 0', () {
    expect(IntRange.singleton(0).contains(0), true);
  });
  test('[0] contains -1', () {
    expect(IntRange.singleton(0).contains(-1), false);
  });
  test('[0] contains 1', () {
    expect(IntRange.singleton(0).contains(1), false);
  });
  // Illegal arguments
  test('illegal arguments IntRange.closed(...)', () {
    expect(() => IntRange.closed(1, 0), throwsA(isException));
  });
  test('illegal arguments IntRange.open(...)', () {
    expect(() => IntRange.open(1, 0), throwsA(isException));
  });
  test('illegal arguments IntRange.closedOpen(...)', () {
    expect(() => IntRange.closedOpen(1, 0), throwsA(isException));
  });
  test('illegal arguments IntRange.openClosed(...)', () {
    expect(() => IntRange.openClosed(1, 0), throwsA(isException));
  });
  test('illegal arguments IntRange(...)', () {
    expect(
      () => IntRange(1, 0, RangeEdgeCondition.open, RangeEdgeCondition.closed),
      throwsA(isException),
    );
  });
}
