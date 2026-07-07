import 'package:test/test.dart';

import 'base/e2e_interactive_group.dart';

void main() {
  e2eInteractiveGroup('interactive session', (setup) {
    test('streams TTY output and accepts input while running', () async {
      final session = await setup.startInteractive('sh', [
        '-c',
        'read name; echo "hello, \$name!"',
      ]);
      try {
        session.sendLine('world');
        final output = await session.waitFor('hello, world!');
        expect(output, contains('hello, world!'));
        await session.done;
        expect(await session.exitCode(), 0);
      } finally {
        await session.close();
      }
    });
  });
}
