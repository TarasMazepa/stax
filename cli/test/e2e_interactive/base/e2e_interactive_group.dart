import 'package:meta/meta.dart';
import 'package:test/scaffolding.dart';

import '../../is_docker_available.dart';
import 'e2e_interactive_test_setup.dart';

export '../../e2e_interactive/docker/interactive_stax_session.dart'
    show InteractiveStaxSession;
export 'e2e_interactive_test_setup.dart' show E2eInteractiveTestSetup;

@isTestGroup
void e2eInteractiveGroup(
  Object? description,
  dynamic Function(E2eInteractiveTestSetup setup) body, {
  String? testOn,
  Timeout? timeout,
  Object? skip,
  Object? tags,
  Map<String, dynamic>? onPlatform = const {
    'windows': Skip('Docker Engine API tests are Unix-only'),
  },
  int? retry,
}) {
  final E2eInteractiveTestSetup setup = E2eInteractiveTestSetup.create();
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
