import 'package:meta/meta.dart';
import 'package:test/scaffolding.dart';

import '../../is_docker_available.dart';
import 'e2e_test_setup.dart';

export 'e2e_test_setup.dart' show E2eTestSetup;

@isTestGroup
void e2eGroup(
  Object? description,
  dynamic Function(E2eTestSetup setup) body, {
  String? testOn,
  Timeout? timeout,
  Object? skip,
  Object? tags,
  Map<String, dynamic>? onPlatform = const {
    'windows': Skip('fails on windows'),
  },
  int? retry,
}) {
  final E2eTestSetup setup = E2eTestSetup.create();
  group(
    description,
    testOn: testOn,
    timeout: timeout,
    skip: isDockerAvailable
        ? skip
        : 'Docker is not installed or daemon is not running',
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
    () {
      setUpAll(() async {
        await setup.buildImages();
      });
      setUp(() async {
        await setup.setUp();
      });
      tearDown(() async {
        await setup.tearDown();
      });
      body(setup);
    },
  );
}
