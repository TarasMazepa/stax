import 'package:test/test.dart';

import 'base/e2e_group.dart';

void main() {
  e2eGroup('about', (containerGetter) {
    test('about', () async {
      final result = await containerGetter().stax(['extras', 'about']);
      expect(result.exitCode, 0);
      expect(result.stdout, '''stax - manage git branches and stack PRs

For more information, visit: https://staxforgit.com/

Copyright (C) ${DateTime.now().year}  Taras Mazepa

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

https://github.com/TarasMazepa/stax/blob/main/LICENSE
''');
    });
  });
}
