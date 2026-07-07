import 'package:meta/meta.dart';
import 'package:test/scaffolding.dart';

import '../../is_docker_available.dart';
import 'e2e2_test_setup.dart';

export '../../e2e2/docker/interactive_stax_session.dart'
    show InteractiveStaxSession;
export 'e2e2_test_setup.dart' show E2e2TestSetup;

@isTestGroup
void e2e2Group(
  Object? description,
  dynamic Function(E2e2TestSetup setup) body, {
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
      body(setup);
    },
  );
}
