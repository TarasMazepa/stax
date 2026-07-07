import 'package:meta/meta.dart';
import 'package:test/scaffolding.dart';

import 'e2e2_container.dart';
import 'e2e2_test_setup.dart';
import '../../is_docker_available.dart';

@isTestGroup
void e2e2Group(
  Object? description,
  dynamic Function(E2e2Container Function()) body, {
  String? testOn,
  Timeout? timeout,
  Object? skip,
  Object? tags,
  Map<String, dynamic>? onPlatform = const {
    'windows': Skip('Docker Engine API tests are Unix-only'),
  },
  int? retry,
}) {
  final E2e2TestSetup setup = E2e2TestSetup.create();
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
      body(() => setup.container);
    },
  );
}
