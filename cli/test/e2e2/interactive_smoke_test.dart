import 'package:test/test.dart';

import 'base/e2e2_group.dart';

void main() {
  e2e2Group('interactive session', (setup) {
    test('streams TTY output and accepts input while running', () async {
      final session = await setup.execInteractive([
        'sh',
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
