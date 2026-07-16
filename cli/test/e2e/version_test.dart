import 'dart:io';

import 'package:test/test.dart';

import 'base/e2e_group.dart';

void main() {
  e2eGroup('version', (setup) {
    test('version', () async {
      final expectedVersion = File(
        '${setup.repositoryRoot}/VERSION',
      ).readAsStringSync().trim();

      final result = await setup.runStax(['extras', 'version']);

      expect(result.stdout, '$expectedVersion\n');
    });
  });
}
