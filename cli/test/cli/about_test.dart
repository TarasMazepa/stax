import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../string_clean_carrige_return_on_windows.dart';
import 'base/cli_group.dart';

void main() {
  cliGroup('about', (setup) {
    test('about', () {
      expect(
        setup
            .runLiveStaxSync(['about'])
            .stdout
            .toString()
            .cleanCarriageReturnOnWindows(),
        '''
stax - manage git branches and stack PRs

For more information, visit: https://staxforgit.com/

Copyright (C) 2025  Taras Mazepa

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
''',
      );
    });
  });
}
