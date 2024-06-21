// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://docs.flutter.dev/cookbook/testing/integration/introduction

import 'package:detect_clap_sound_flutter/detect_clap_sound_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getStatusPermission test', (WidgetTester tester) async {
    final DetectClapSoundFlutter plugin = DetectClapSoundFlutter();
    final bool? status = await plugin.hasPermission();
    // The version string depends on the host platform running the test, so
    // just assert that some non-empty string is returned.
    expect(status, true);
  });
}
