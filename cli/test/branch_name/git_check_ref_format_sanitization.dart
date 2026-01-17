import 'package:stax/branch_name/git_check_ref_format_based_sanitization.dart';
import 'package:test/test.dart';

void main() {
  test('_', () {
    expect(gitCheckRefFormatBasedSanitization('_'), '_');
  });
  test('.', () {
    expect(gitCheckRefFormatBasedSanitization('.'), '');
  });
  test('.a', () {
    expect(gitCheckRefFormatBasedSanitization('.a'), 'a');
  });
  test('a..', () {
    expect(gitCheckRefFormatBasedSanitization('a..'), 'a');
  });
  test('a..a', () {
    expect(gitCheckRefFormatBasedSanitization('a..a'), 'a.a');
  });
  test('@', () {
    expect(gitCheckRefFormatBasedSanitization('@'), '');
  });
  test('@.', () {
    expect(gitCheckRefFormatBasedSanitization('@.'), '');
  });
  test('@..', () {
    expect(gitCheckRefFormatBasedSanitization('@..'), '');
  });
  test('@{', () {
    expect(gitCheckRefFormatBasedSanitization('@{'), '');
  });
  test('a@{b', () {
    expect(gitCheckRefFormatBasedSanitization('a@{b'), 'a@b');
  });
  test('a/./././././.', () {
    expect(gitCheckRefFormatBasedSanitization('a/./././././.'), 'a');
  });
  test('a/./././././.a', () {
    expect(gitCheckRefFormatBasedSanitization('a/./././././.a'), 'a/a');
  });
  test('.lock', () {
    expect(gitCheckRefFormatBasedSanitization('.lock'), 'lock');
  });
  test('.lock/.lock', () {
    expect(gitCheckRefFormatBasedSanitization('.lock/.lock'), 'lock/lock');
  });
  test('a.lock/a.lock/a.lock', () {
    expect(
      gitCheckRefFormatBasedSanitization('a.lock/a.lock/a.lock'),
      'a.locka.locka.loc',
    );
  });
  test('foo/.lock/bar', () {
    expect(gitCheckRefFormatBasedSanitization('foo/.lock/bar'), 'foo/lock/bar');
  });
  test('foo.lock/bar', () {
    expect(gitCheckRefFormatBasedSanitization('foo.lock/bar'), 'foo.lockbar');
  });
  test('---foo', () {
    expect(gitCheckRefFormatBasedSanitization('---foo'), 'foo');
  });
  test('abcdefghijklmnop', () {
    expect(
      gitCheckRefFormatBasedSanitization('abcdefghijklmnop'),
      'abcdefghijklmnop',
    );
  });
  // Basic valid names
  test('simple-branch', () {
    expect(
      gitCheckRefFormatBasedSanitization('simple-branch'),
      'simple-branch',
    );
  });

  test('feature/user-auth', () {
    expect(
      gitCheckRefFormatBasedSanitization('feature/user-auth'),
      'feature/user-auth',
    );
  });

  test('UPPERCASE_mixed_123', () {
    expect(
      gitCheckRefFormatBasedSanitization('UPPERCASE_mixed_123'),
      'UPPERCASE_mixed_123',
    );
  });

  test('underscore_separator', () {
    expect(
      gitCheckRefFormatBasedSanitization('underscore_separator'),
      'underscore_separator',
    );
  });

  // Spaces and whitespace
  test('create a function', () {
    expect(
      gitCheckRefFormatBasedSanitization('create a function'),
      'create-a-function',
    );
  });

  test('multiple   spaces', () {
    expect(
      gitCheckRefFormatBasedSanitization('multiple   spaces'),
      'multiple-spaces',
    );
  });

  test('leading space', () {
    expect(gitCheckRefFormatBasedSanitization('  leading'), 'leading');
  });

  test('trailing space', () {
    expect(gitCheckRefFormatBasedSanitization('trailing  '), 'trailing');
  });

  test('tabs and newlines', () {
    expect(
      gitCheckRefFormatBasedSanitization('has\ttabs\nand\nnewlines'),
      'has-tabs-and-newlines',
    );
  });

  test('only spaces', () {
    expect(gitCheckRefFormatBasedSanitization('   '), '');
  });

  // Leading characters
  test('leading dash', () {
    expect(gitCheckRefFormatBasedSanitization('-leading-dash'), 'leading-dash');
  });

  test('multiple leading dashes', () {
    expect(gitCheckRefFormatBasedSanitization('---many-dashes'), 'many-dashes');
  });

  test('leading dot', () {
    expect(
      gitCheckRefFormatBasedSanitization('.hidden-branch'),
      'hidden-branch',
    );
  });

  test('leading slash', () {
    expect(
      gitCheckRefFormatBasedSanitization('/feature/branch'),
      'feature/branch',
    );
  });

  test('leading dash dot slash combo', () {
    expect(gitCheckRefFormatBasedSanitization('-./.foo'), 'foo');
  });

  // Trailing characters
  test('trailing dot', () {
    expect(gitCheckRefFormatBasedSanitization('branch.'), 'branch');
  });

  test('trailing slash', () {
    expect(
      gitCheckRefFormatBasedSanitization('feature/branch/'),
      'feature/branch',
    );
  });

  test('trailing dots', () {
    expect(gitCheckRefFormatBasedSanitization('branch...'), 'branch');
  });

  test('trailing slashes', () {
    expect(gitCheckRefFormatBasedSanitization('feature///'), 'feature');
  });

  // Consecutive characters
  test('consecutive dots', () {
    expect(gitCheckRefFormatBasedSanitization('hello..world'), 'hello.world');
  });

  test('many consecutive dots', () {
    expect(gitCheckRefFormatBasedSanitization('foo....bar'), 'foo.bar');
  });

  test('consecutive slashes', () {
    expect(
      gitCheckRefFormatBasedSanitization('feature//bugfix'),
      'feature/bugfix',
    );
  });

  test('consecutive dashes', () {
    expect(gitCheckRefFormatBasedSanitization('foo---bar'), 'foo-bar');
  });

  test('mixed consecutive', () {
    expect(gitCheckRefFormatBasedSanitization('a..b//c---d'), 'a.b/c-d');
  });

  // Forbidden characters
  test('tilde', () {
    expect(gitCheckRefFormatBasedSanitization('branch~1'), 'branch-1');
  });

  test('caret', () {
    expect(gitCheckRefFormatBasedSanitization('branch^2'), 'branch-2');
  });

  test('colon', () {
    expect(
      gitCheckRefFormatBasedSanitization('fix: parser bug'),
      'fix-parser-bug',
    );
  });

  test('question mark', () {
    expect(
      gitCheckRefFormatBasedSanitization('is this valid?'),
      'is-this-valid',
    );
  });

  test('asterisk', () {
    expect(gitCheckRefFormatBasedSanitization('feature/*'), 'feature');
  });

  test('brackets', () {
    expect(gitCheckRefFormatBasedSanitization('branch[123]'), 'branch-123]');
  });

  test('backslash', () {
    expect(
      gitCheckRefFormatBasedSanitization('path\\to\\branch'),
      'path-to-branch',
    );
  });

  test('multiple forbidden chars', () {
    expect(gitCheckRefFormatBasedSanitization('~^:?*[\\'), '');
  });

  test('forbidden chars mixed with valid', () {
    expect(
      gitCheckRefFormatBasedSanitization('foo~bar^baz:qux'),
      'foo-bar-baz-qux',
    );
  });

  // @{ sequence
  test('reflog notation', () {
    expect(gitCheckRefFormatBasedSanitization('branch@{1}'), 'branch@1}');
  });

  test('@ with curly brace', () {
    expect(gitCheckRefFormatBasedSanitization('my@{previous}'), 'my@previous}');
  });

  test('standalone @', () {
    expect(gitCheckRefFormatBasedSanitization('@'), '');
  });

  test('@ in middle', () {
    expect(gitCheckRefFormatBasedSanitization('user@branch'), 'user@branch');
  });

  test('@ at end', () {
    expect(gitCheckRefFormatBasedSanitization('branch@'), 'branch@');
  });

  test('multiple @{', () {
    expect(gitCheckRefFormatBasedSanitization('a@{b}@{c}'), 'a@b}@c}');
  });

  // .lock suffix
  test('.lock at end', () {
    expect(gitCheckRefFormatBasedSanitization('branch.lock'), 'branch.loc');
  });

  test('.lock in component', () {
    expect(
      gitCheckRefFormatBasedSanitization('feature/.lock/branch'),
      'feature/lock/branch',
    );
  });

  test('.lock multiple components', () {
    expect(
      gitCheckRefFormatBasedSanitization('foo.lock/bar.lock'),
      'foo.lockbar.loc',
    );
  });

  test('.lock not at boundary', () {
    expect(
      gitCheckRefFormatBasedSanitization('branch.locked'),
      'branch.locked',
    );
  });

  test('.LOCK uppercase', () {
    expect(gitCheckRefFormatBasedSanitization('branch.LOCK'), 'branch.LOCK');
  });

  // Hierarchical paths
  test('deep hierarchy', () {
    expect(
      gitCheckRefFormatBasedSanitization('team/proj/feature/auth'),
      'team/proj/feature/auth',
    );
  });

  test('hierarchy with spaces', () {
    expect(
      gitCheckRefFormatBasedSanitization('feature / user auth / login'),
      'feature-/-user-auth-/-login',
    );
  });

  test('dot in component', () {
    expect(
      gitCheckRefFormatBasedSanitization('feature/v2.1.0'),
      'feature/v2.1.0',
    );
  });

  test('leading dot in component', () {
    expect(
      gitCheckRefFormatBasedSanitization('feature/.hidden'),
      'feature/hidden',
    );
  });

  test('empty components', () {
    expect(
      gitCheckRefFormatBasedSanitization('feature//branch'),
      'feature/branch',
    );
  });

  test('many empty components', () {
    expect(gitCheckRefFormatBasedSanitization('a///b////c'), 'a/b/c');
  });

  // Special patterns
  test('jira ticket', () {
    expect(
      gitCheckRefFormatBasedSanitization('PROJ-123: Add user login'),
      'PROJ-123-Add-user-login',
    );
  });

  test('github issue', () {
    expect(
      gitCheckRefFormatBasedSanitization('fix #42 parser'),
      'fix-#42-parser',
    );
  });

  test('semantic commit', () {
    expect(
      gitCheckRefFormatBasedSanitization('feat(auth): oauth2'),
      'feat(auth)-oauth2',
    );
  });

  test('date format', () {
    expect(
      gitCheckRefFormatBasedSanitization('release/2024-01-15'),
      'release/2024-01-15',
    );
  });

  test('version number', () {
    expect(gitCheckRefFormatBasedSanitization('v2.1.0'), 'v2.1.0');
  });

  test('camelCase', () {
    expect(
      gitCheckRefFormatBasedSanitization('addUserAuthentication'),
      'addUserAuthentication',
    );
  });

  test('snake_case', () {
    expect(
      gitCheckRefFormatBasedSanitization('add_user_authentication'),
      'add_user_authentication',
    );
  });

  // Edge cases with control characters
  test('ASCII control chars', () {
    expect(gitCheckRefFormatBasedSanitization('branch\x00\x01\x1F'), 'branch');
  });

  test('DEL character', () {
    expect(gitCheckRefFormatBasedSanitization('branch\x7Ftest'), 'branch-test');
  });

  // Unicode and emojis
  test('emoji', () {
    expect(
      gitCheckRefFormatBasedSanitization('feature-🚀-launch'),
      'feature-🚀-launch',
    );
  });

  test('accented characters', () {
    expect(gitCheckRefFormatBasedSanitization('café-brûlée'), 'café-brûlée');
  });

  test('cyrillic', () {
    expect(
      gitCheckRefFormatBasedSanitization('ветка-функция'),
      'ветка-функция',
    );
  });

  test('chinese characters', () {
    expect(gitCheckRefFormatBasedSanitization('功能-分支'), '功能-分支');
  });

  // Empty and minimal cases
  test('empty string', () {
    expect(gitCheckRefFormatBasedSanitization(''), '');
  });

  test('single valid char', () {
    expect(gitCheckRefFormatBasedSanitization('a'), 'a');
  });

  test('single dash', () {
    expect(gitCheckRefFormatBasedSanitization('-'), '');
  });

  test('single dot', () {
    expect(gitCheckRefFormatBasedSanitization('.'), '');
  });

  test('single slash', () {
    expect(gitCheckRefFormatBasedSanitization('/'), '');
  });

  test('only invalid chars', () {
    expect(gitCheckRefFormatBasedSanitization('~~~^^^:::'), '');
  });

  // Complex real-world examples
  test('conventional commit with scope', () {
    expect(
      gitCheckRefFormatBasedSanitization('feat(api): add user endpoint'),
      'feat(api)-add-user-endpoint',
    );
  });

  test('github issue with description', () {
    expect(
      gitCheckRefFormatBasedSanitization('42 - Fix login bug'),
      '42-Fix-login-bug',
    );
  });

  test('date-based branch', () {
    expect(
      gitCheckRefFormatBasedSanitization('hotfix/2024.01.15-critical-fix'),
      'hotfix/2024.01.15-critical-fix',
    );
  });

  test('user/feature pattern', () {
    expect(
      gitCheckRefFormatBasedSanitization('john.doe/feature/auth'),
      'john.doe/feature/auth',
    );
  });

  test('ticket with forbidden chars', () {
    expect(
      gitCheckRefFormatBasedSanitization('JIRA-123: Fix bug? (urgent)'),
      'JIRA-123-Fix-bug-(urgent)',
    );
  });

  test('path-like branch', () {
    expect(
      gitCheckRefFormatBasedSanitization('release/v2.0/rc-1'),
      'release/v2.0/rc-1',
    );
  });

  // Stress tests
  test('very long valid name', () {
    final long = 'a' * 100;
    expect(gitCheckRefFormatBasedSanitization(long), long);
  });

  test('many components', () {
    expect(
      gitCheckRefFormatBasedSanitization('a/b/c/d/e/f/g/h/i/j'),
      'a/b/c/d/e/f/g/h/i/j',
    );
  });

  test('alternating valid and invalid', () {
    expect(
      gitCheckRefFormatBasedSanitization('a~b^c:d?e*f[g\\h'),
      'a-b-c-d-e-f-g-h',
    );
  });

  test('all types of separators', () {
    expect(gitCheckRefFormatBasedSanitization('a-b_c/d.e'), 'a-b_c/d.e');
  });

  // Mixed edge cases
  test('leading and trailing mixed', () {
    expect(
      gitCheckRefFormatBasedSanitization('---...///branch---...///'),
      'branch',
    );
  });

  test('dot before slash', () {
    expect(
      gitCheckRefFormatBasedSanitization('feature./branch'),
      'feature./branch',
    );
  });

  test('slash before dot', () {
    expect(
      gitCheckRefFormatBasedSanitization('feature/.branch'),
      'feature/branch',
    );
  });

  test('dash around slash', () {
    expect(
      gitCheckRefFormatBasedSanitization('feature-/-branch'),
      'feature-/-branch',
    );
  });

  test('complex cleanup needed', () {
    expect(
      gitCheckRefFormatBasedSanitization('  --..//~~feature  :  branch??  '),
      'feature-branch',
    );
  });

  test('numbers only', () {
    expect(gitCheckRefFormatBasedSanitization('12345'), '12345');
  });

  test('starts with number', () {
    expect(gitCheckRefFormatBasedSanitization('123-feature'), '123-feature');
  });

  test('special chars at boundaries', () {
    expect(gitCheckRefFormatBasedSanitization('~feature~'), 'feature');
  });

  test('lock with different cases', () {
    expect(gitCheckRefFormatBasedSanitization('test.Lock'), 'test.Lock');
  });

  test('lock in middle of word', () {
    expect(gitCheckRefFormatBasedSanitization('unlock'), 'unlock');
  });

  // More .lock edge cases
  test('.lock.lock', () {
    expect(gitCheckRefFormatBasedSanitization('.lock.lock'), 'lock.loc');
  });

  test('a.lock.lock', () {
    expect(gitCheckRefFormatBasedSanitization('a.lock.lock'), 'a.lock.loc');
  });

  test('.loc (not .lock)', () {
    expect(gitCheckRefFormatBasedSanitization('.loc'), 'loc');
  });

  test('lock without dot', () {
    expect(gitCheckRefFormatBasedSanitization('lock'), 'lock');
  });

  test('alock (lock at end without dot)', () {
    expect(gitCheckRefFormatBasedSanitization('alock'), 'alock');
  });

  test('.lockfile', () {
    expect(gitCheckRefFormatBasedSanitization('.lockfile'), 'lockfile');
  });

  test('a/.lock.lock/.lock', () {
    expect(
      gitCheckRefFormatBasedSanitization('a/.lock.lock/.lock'),
      'a/lock.lock.loc',
    );
  });

  // More @{ edge cases
  test('@{@{', () {
    expect(gitCheckRefFormatBasedSanitization('@{@{'), '@@');
  });

  test('@@', () {
    expect(gitCheckRefFormatBasedSanitization('@@'), '@@');
  });

  test('@@@{', () {
    expect(gitCheckRefFormatBasedSanitization('@@@{'), '@@@');
  });

  test('{alone', () {
    expect(gitCheckRefFormatBasedSanitization('{'), '{');
  });

  test('}alone', () {
    expect(gitCheckRefFormatBasedSanitization('}'), '}');
  });

  test('a{b}c', () {
    expect(gitCheckRefFormatBasedSanitization('a{b}c'), 'a{b}c');
  });

  test('@a{b}', () {
    expect(gitCheckRefFormatBasedSanitization('@a{b}'), '@a{b}');
  });

  test('@}', () {
    expect(gitCheckRefFormatBasedSanitization('@}'), '@}');
  });

  // Consecutive dots with other characters
  test('a...b', () {
    expect(gitCheckRefFormatBasedSanitization('a...b'), 'a.b');
  });

  test('a....b', () {
    expect(gitCheckRefFormatBasedSanitization('a....b'), 'a.b');
  });

  test('..a..', () {
    expect(gitCheckRefFormatBasedSanitization('..a..'), 'a');
  });

  test('a..b..c', () {
    expect(gitCheckRefFormatBasedSanitization('a..b..c'), 'a.b.c');
  });

  // Slash combinations
  test('///', () {
    expect(gitCheckRefFormatBasedSanitization('///'), '');
  });

  test('a///b', () {
    expect(gitCheckRefFormatBasedSanitization('a///b'), 'a/b');
  });

  test('a////b', () {
    expect(gitCheckRefFormatBasedSanitization('a////b'), 'a/b');
  });

  test('/a/b/', () {
    expect(gitCheckRefFormatBasedSanitization('/a/b/'), 'a/b');
  });

  test('//a//b//', () {
    expect(gitCheckRefFormatBasedSanitization('//a//b//'), 'a/b');
  });

  // Dash combinations
  test('----', () {
    expect(gitCheckRefFormatBasedSanitization('----'), '');
  });

  test('a----b', () {
    expect(gitCheckRefFormatBasedSanitization('a----b'), 'a-b');
  });

  test('-a-', () {
    expect(gitCheckRefFormatBasedSanitization('-a-'), 'a');
  });

  test('--a--', () {
    expect(gitCheckRefFormatBasedSanitization('--a--'), 'a');
  });

  // Mixed forbidden characters in sequence
  test('~^:', () {
    expect(gitCheckRefFormatBasedSanitization('~^:'), '');
  });

  test('a~^:b', () {
    expect(gitCheckRefFormatBasedSanitization('a~^:b'), 'a-b');
  });

  test('~~~a^^^b:::c', () {
    expect(gitCheckRefFormatBasedSanitization('~~~a^^^b:::c'), 'a-b-c');
  });

  // Special character edge cases
  test('] alone (closing bracket)', () {
    expect(gitCheckRefFormatBasedSanitization(']'), ']');
  });

  test('a]b', () {
    expect(gitCheckRefFormatBasedSanitization('a]b'), 'a]b');
  });

  test('[a]', () {
    expect(gitCheckRefFormatBasedSanitization('[a]'), 'a]');
  });

  test('[[', () {
    expect(gitCheckRefFormatBasedSanitization('[['), '');
  });

  test(']]', () {
    expect(gitCheckRefFormatBasedSanitization(']]'), ']]');
  });

  test('()alone', () {
    expect(gitCheckRefFormatBasedSanitization('()'), '()');
  });

  test('a(b)c', () {
    expect(gitCheckRefFormatBasedSanitization('a(b)c'), 'a(b)c');
  });

  test('#alone', () {
    expect(gitCheckRefFormatBasedSanitization('#'), '#');
  });

  test('\$alone', () {
    expect(gitCheckRefFormatBasedSanitization('\$'), '\$');
  });

  test('a\$b', () {
    expect(gitCheckRefFormatBasedSanitization('a\$b'), 'a\$b');
  });

  test('%alone', () {
    expect(gitCheckRefFormatBasedSanitization('%'), '%');
  });

  test('&alone', () {
    expect(gitCheckRefFormatBasedSanitization('&'), '&');
  });

  // Combinations of dots, slashes, dashes
  test('.-/', () {
    expect(gitCheckRefFormatBasedSanitization('.-/'), '');
  });

  test('a.-/b', () {
    expect(gitCheckRefFormatBasedSanitization('a.-/b'), 'a.-/b');
  });

  test('a/./b', () {
    expect(gitCheckRefFormatBasedSanitization('a/./b'), 'a/b');
  });

  test('a/../b', () {
    expect(gitCheckRefFormatBasedSanitization('a/../b'), 'a/b');
  });

  test('a/.../b', () {
    expect(gitCheckRefFormatBasedSanitization('a/.../b'), 'a/b');
  });

  test('a/-/b', () {
    expect(gitCheckRefFormatBasedSanitization('a/-/b'), 'a/-/b');
  });

  test('a/--/b', () {
    expect(gitCheckRefFormatBasedSanitization('a/--/b'), 'a/-/b');
  });

  test('a/.b', () {
    expect(gitCheckRefFormatBasedSanitization('a/.b'), 'a/b');
  });

  test('a/b.', () {
    expect(gitCheckRefFormatBasedSanitization('a/b.'), 'a/b');
  });

  test('a./b', () {
    expect(gitCheckRefFormatBasedSanitization('a./b'), 'a./b');
  });

  // Whitespace variations
  test('\\t (tab)', () {
    expect(gitCheckRefFormatBasedSanitization('\t'), '');
  });

  test('\\n (newline)', () {
    expect(gitCheckRefFormatBasedSanitization('\n'), '');
  });

  test('\\r (carriage return)', () {
    expect(gitCheckRefFormatBasedSanitization('\r'), '');
  });

  test('\\r\\n (CRLF)', () {
    expect(gitCheckRefFormatBasedSanitization('\r\n'), '');
  });

  test('a\\tb\\nc', () {
    expect(gitCheckRefFormatBasedSanitization('a\tb\nc'), 'a-b-c');
  });

  test('multiple whitespace types', () {
    expect(gitCheckRefFormatBasedSanitization('a \t\n\rb'), 'a-b');
  });

  // Leading/trailing combinations
  test('---...///', () {
    expect(gitCheckRefFormatBasedSanitization('---...///'), '');
  });

  test('...---///', () {
    expect(gitCheckRefFormatBasedSanitization('...---///'), '');
  });

  test('///...---', () {
    expect(gitCheckRefFormatBasedSanitization('///...---'), '');
  });

  test('.-./.-.', () {
    expect(gitCheckRefFormatBasedSanitization('.-./.-.'), '');
  });

  // Very short valid names
  test('a/b', () {
    expect(gitCheckRefFormatBasedSanitization('a/b'), 'a/b');
  });

  test('1', () {
    expect(gitCheckRefFormatBasedSanitization('1'), '1');
  });

  test('_a', () {
    expect(gitCheckRefFormatBasedSanitization('_a'), '_a');
  });

  test('a_', () {
    expect(gitCheckRefFormatBasedSanitization('a_'), 'a_');
  });

  // Numbers and special patterns
  test('0', () {
    expect(gitCheckRefFormatBasedSanitization('0'), '0');
  });

  test('123/456', () {
    expect(gitCheckRefFormatBasedSanitization('123/456'), '123/456');
  });

  test('v1.2.3', () {
    expect(gitCheckRefFormatBasedSanitization('v1.2.3'), 'v1.2.3');
  });

  test('1.0.0.0', () {
    expect(gitCheckRefFormatBasedSanitization('1.0.0.0'), '1.0.0.0');
  });

  // Real-world patterns
  test('WIP: work in progress', () {
    expect(
      gitCheckRefFormatBasedSanitization('WIP: work in progress'),
      'WIP-work-in-progress',
    );
  });

  test('[RFC] proposal', () {
    expect(
      gitCheckRefFormatBasedSanitization('[RFC] proposal'),
      'RFC]-proposal',
    );
  });

  test('user/john.smith/feature', () {
    expect(
      gitCheckRefFormatBasedSanitization('user/john.smith/feature'),
      'user/john.smith/feature',
    );
  });

  test('team-a/sprint-15/story-42', () {
    expect(
      gitCheckRefFormatBasedSanitization('team-a/sprint-15/story-42'),
      'team-a/sprint-15/story-42',
    );
  });

  test('2024-Q1-planning', () {
    expect(
      gitCheckRefFormatBasedSanitization('2024-Q1-planning'),
      '2024-Q1-planning',
    );
  });

  test('v2.0.0-rc.1', () {
    expect(gitCheckRefFormatBasedSanitization('v2.0.0-rc.1'), 'v2.0.0-rc.1');
  });

  test('hotfix-2024.01.15', () {
    expect(
      gitCheckRefFormatBasedSanitization('hotfix-2024.01.15'),
      'hotfix-2024.01.15',
    );
  });

  // Unicode edge cases
  test('emoji at start', () {
    expect(gitCheckRefFormatBasedSanitization('🚀feature'), '🚀feature');
  });

  test('emoji at end', () {
    expect(gitCheckRefFormatBasedSanitization('feature🚀'), 'feature🚀');
  });

  test('multiple emojis', () {
    expect(gitCheckRefFormatBasedSanitization('🚀🔥💯'), '🚀🔥💯');
  });

  test('emoji with spaces', () {
    expect(
      gitCheckRefFormatBasedSanitization('feature 🚀 launch'),
      'feature-🚀-launch',
    );
  });

  test('mixed scripts', () {
    expect(
      gitCheckRefFormatBasedSanitization('feature-功能-feature'),
      'feature-功能-feature',
    );
  });

  // Combination stress tests
  test('all separators together', () {
    expect(gitCheckRefFormatBasedSanitization('a-_./b'), 'a-_./b');
  });

  test('separators with forbidden', () {
    expect(gitCheckRefFormatBasedSanitization('a-_~^:?*b'), 'a-_-b');
  });

  test('deeply nested with .lock', () {
    expect(
      gitCheckRefFormatBasedSanitization('a/b/c.lock/d/e.lock'),
      'a/b/c.lockd/e.loc',
    );
  });

  test('every forbidden char', () {
    expect(gitCheckRefFormatBasedSanitization(' \t\n\r\x00\x7F~^:?*[\\'), '');
  });

  test('forbidden sandwich', () {
    expect(gitCheckRefFormatBasedSanitization('~~~valid~~~'), 'valid');
  });

  test('alternating dash and dot', () {
    expect(gitCheckRefFormatBasedSanitization('a-b.c-d.e'), 'a-b.c-d.e');
  });

  test('max nesting', () {
    expect(
      gitCheckRefFormatBasedSanitization('a/b/c/d/e/f/g/h/i/j/k/l/m/n/o/p'),
      'a/b/c/d/e/f/g/h/i/j/k/l/m/n/o/p',
    );
  });

  // Pathological cases
  test('alternating valid invalid', () {
    expect(gitCheckRefFormatBasedSanitization('a~b~c~d~e~f'), 'a-b-c-d-e-f');
  });

  test('dots and slashes maze', () {
    expect(gitCheckRefFormatBasedSanitization('a/./b/../c/.../d'), 'a/b/c/d');
  });

  test('everything at once', () {
    expect(
      gitCheckRefFormatBasedSanitization('  --..//~~@@{feature:.lock~test//  '),
      '@@feature-.lock-test',
    );
  });

  // Single character tests
  test('a', () {
    expect(gitCheckRefFormatBasedSanitization('a'), 'a');
  });

  test('A', () {
    expect(gitCheckRefFormatBasedSanitization('A'), 'A');
  });

  test('0', () {
    expect(gitCheckRefFormatBasedSanitization('0'), '0');
  });

  test('~', () {
    expect(gitCheckRefFormatBasedSanitization('~'), '');
  });

  test('^', () {
    expect(gitCheckRefFormatBasedSanitization('^'), '');
  });

  test(':', () {
    expect(gitCheckRefFormatBasedSanitization(':'), '');
  });

  test('?', () {
    expect(gitCheckRefFormatBasedSanitization('?'), '');
  });

  test('*', () {
    expect(gitCheckRefFormatBasedSanitization('*'), '');
  });

  test('[', () {
    expect(gitCheckRefFormatBasedSanitization('['), '');
  });

  test('\\', () {
    expect(gitCheckRefFormatBasedSanitization('\\'), '');
  });

  // Boundary behavior
  test('254 character component', () {
    final longComponent = 'a' * 250;
    expect(gitCheckRefFormatBasedSanitization(longComponent), longComponent);
  });

  test('multiple 100 char components', () {
    final comp = 'a' * 100;
    expect(
      gitCheckRefFormatBasedSanitization('$comp/$comp/$comp'),
      '$comp/$comp/${'a' * 48}',
    );
  });

  // More realistic branch names
  test('dependabot/npm_and_yarn/axios-1.6.0', () {
    expect(
      gitCheckRefFormatBasedSanitization('dependabot/npm_and_yarn/axios-1.6.0'),
      'dependabot/npm_and_yarn/axios-1.6.0',
    );
  });

  test('renovate/major-react-monorepo', () {
    expect(
      gitCheckRefFormatBasedSanitization('renovate/major-react-monorepo'),
      'renovate/major-react-monorepo',
    );
  });

  test('revert-123-fix-login-bug', () {
    expect(
      gitCheckRefFormatBasedSanitization('revert-123-fix-login-bug'),
      'revert-123-fix-login-bug',
    );
  });

  test('cherry-pick-abc123', () {
    expect(
      gitCheckRefFormatBasedSanitization('cherry-pick-abc123'),
      'cherry-pick-abc123',
    );
  });

  test('newline', () {
    expect(
      gitCheckRefFormatBasedSanitization('\n'),
      '',
    );
  });
}
