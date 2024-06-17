import 'package:meta/meta.dart';
import 'package:test/scaffolding.dart';

import 'cli_test_setup.dart';

@isTestGroup
void cliGroup(Object? description, dynamic Function(CliTestSetup setup) body,
    {String? testOn,
    Timeout? timeout,
    Object? skip,
    Object? tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
    bool bundle = false,
    @Deprecated('Debug only') bool solo = false}) {
  final CliTestSetup setup = CliTestSetup.create(bundle);
  group(description,
      testOn: testOn,
      timeout: timeout,
      skip: skip,
      tags: tags,
      onPlatform: onPlatform,
      retry: retry, () {
    setUp(() {
      setup.setUp();
      setup.runSync("git", ["config", "--global", "user.name", "stax"]);
      setup.runSync(
          "git", ["config", "--global", "user.email", "stax@staxforgit.com"]);
    });
    tearDown(() {
      setup.tearDown();
    });
    body(setup);
  });
}
