import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:detect_clap_sound_flutter/src/detect_clap_sound_flutter_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDetectClapSoundFlutter platform = MethodChannelDetectClapSoundFlutter();
  const MethodChannel channel = MethodChannel('detect_clap_sound_flutter');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getStatusPermission', () async {
    expect(await platform.hasPermission(), true);
  });
}
