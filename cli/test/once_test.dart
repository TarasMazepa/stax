import 'package:stax/once.dart';
import 'package:test/test.dart';

void main() {
  test('once attempt', () {
    final once = Once();
    int executions = 0;
    call() => executions++;
    expect(executions, 0);
    once.attempt(call);
    expect(executions, 1);
    once.attempt(call);
    expect(executions, 1);
    call();
    expect(executions, 2);
    once.attempt(call);
    expect(executions, 2);
  });
  test('once wrap', () {
    final once = Once();
    int executions = 0;
    final call = once.wrap(() => executions++);
    expect(executions, 0);
    call();
    expect(executions, 1);
    call();
    expect(executions, 1);
    once.attempt(call);
    expect(executions, 1);
  });
}
