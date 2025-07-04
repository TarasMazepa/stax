import 'package:stax/context/context.dart';
import 'package:test/test.dart';

void main() {
  test('implicit', () {
    final context = Context.implicit();
    expect(context.quiet, false);
    expect(context.workingDirectory, null);
    expect(context.forcedVerbosity, false);
    expect(context.acceptAll, false);
    expect(context.declineAll, false);
  });
  test('explicit', () {
    final context = Context(true, 'directory', true, true, true);
    expect(context.quiet, true);
    expect(context.workingDirectory, 'directory');
    expect(context.forcedVerbosity, true);
    expect(context.acceptAll, true);
    expect(context.declineAll, true);
  });
  test('implicit not changing withQuiet', () {
    final context = Context.implicit();
    Context modifiedContext = context.withQuiet(false);
    expect(context, (c) => identical(c, modifiedContext));
  });
  test('implicit not changing withWorkingDirectory', () {
    final context = Context.implicit();
    Context modifiedContext = context.withWorkingDirectory(null);
    expect(context, (c) => identical(c, modifiedContext));
  });
  test('implicit not changing withForcedVerbosity', () {
    final context = Context.implicit();
    Context modifiedContext = context.withForcedVerbosity(false);
    expect(context, (c) => identical(c, modifiedContext));
  });
  test('explicit not changing withQuiet', () {
    final context = Context(true, 'directory', true, true, true);
    Context modifiedContext = context.withQuiet(true);
    expect(context, (c) => identical(c, modifiedContext));
  });
  test('explicit not changing withWorkingDirectory', () {
    final context = Context(true, 'directory', true, true, true);
    Context modifiedContext = context.withWorkingDirectory('directory');
    expect(context, (c) => identical(c, modifiedContext));
  });
  test('explicit not changing withForcedVerbosity', () {
    final context = Context(true, 'directory', true, true, true);
    Context modifiedContext = context.withForcedVerbosity(true);
    expect(context, (c) => identical(c, modifiedContext));
  });
  test('implicit changing withQuiet', () {
    final context = Context.implicit();
    Context modifiedContext = context.withQuiet(true);
    expect(context, (c) => !identical(c, modifiedContext));
    expect(context.quiet, false);
    expect(modifiedContext.quiet, true);
  });
  test('implicit changing withWorkingDirectory', () {
    final context = Context.implicit();
    Context modifiedContext = context.withWorkingDirectory('directory');
    expect(context, (c) => !identical(c, modifiedContext));
    expect(context.workingDirectory, null);
    expect(modifiedContext.workingDirectory, 'directory');
  });
  test('implicit changing withForcedVerbosity', () {
    final context = Context.implicit();
    Context modifiedContext = context.withForcedVerbosity(true);
    expect(context, (c) => !identical(c, modifiedContext));
    expect(context.forcedVerbosity, false);
    expect(modifiedContext.forcedVerbosity, true);
  });
  test('explicit changing withQuiet', () {
    final context = Context(true, 'directory', true, true, true);
    Context modifiedContext = context.withQuiet(false);
    expect(context, (c) => !identical(c, modifiedContext));
    expect(context.quiet, true);
    expect(modifiedContext.quiet, false);
  });
  test('explicit changing withWorkingDirectory', () {
    final context = Context(true, 'directory', true, true, true);
    Context modifiedContext = context.withWorkingDirectory(null);
    expect(context, (c) => !identical(c, modifiedContext));
    expect(context.workingDirectory, 'directory');
    expect(modifiedContext.workingDirectory, null);
  });
  test('explicit changing withForcedVerbosity', () {
    final context = Context(true, 'directory', true, true, true);
    Context modifiedContext = context.withForcedVerbosity(false);
    expect(context, (c) => !identical(c, modifiedContext));
    expect(context.forcedVerbosity, true);
    expect(modifiedContext.forcedVerbosity, false);
  });
}
