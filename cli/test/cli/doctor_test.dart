import 'dart:convert';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import '../string_clean_carrige_return_on_windows.dart';
import 'base/cli_group.dart';

void main() {
  cliGroup('doctor', (setup) {
    test('doctor writes regular output without json flag', () {
      final output = setup
          .runLiveStaxSync(['extras', 'doctor'])
          .stdout
          .toString()
          .cleanCarriageReturnOnWindows();
      expect(output.isNotEmpty, true);
      // It should print checkmarks and command outputs
      expect(output.contains('git config --get user.name'), true);
      expect(output.contains('git config --get user.email'), true);
      expect(output.startsWith('['), true);
    });

    test('doctor writes json output with --json flag', () {
      final output = setup
          .runLiveStaxSync(['extras', 'doctor', '--json'])
          .stdout
          .toString()
          .cleanCarriageReturnOnWindows();
      expect(output.isNotEmpty, true);

      final parsed = jsonDecode(output) as List;
      expect(parsed.isNotEmpty, true);

      final firstItem = parsed.first as Map<String, dynamic>;
      expect(firstItem.containsKey('name'), true);
      expect(firstItem.containsKey('success'), true);
      expect(firstItem.containsKey('output'), true);
      expect(firstItem['name'], 'git config --get user.name');
    });
  });
}
