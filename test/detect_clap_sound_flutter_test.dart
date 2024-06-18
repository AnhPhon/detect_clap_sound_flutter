import 'package:flutter_test/flutter_test.dart';
import 'package:detect_clap_sound_flutter/detect_clap_sound_flutter.dart';
import 'package:detect_clap_sound_flutter/detect_clap_sound_flutter_platform_interface.dart';
import 'package:detect_clap_sound_flutter/detect_clap_sound_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDetectClapSoundFlutterPlatform
    with MockPlatformInterfaceMixin
    implements DetectClapSoundFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DetectClapSoundFlutterPlatform initialPlatform = DetectClapSoundFlutterPlatform.instance;

  test('$MethodChannelDetectClapSoundFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDetectClapSoundFlutter>());
  });

  test('getPlatformVersion', () async {
    DetectClapSoundFlutter detectClapSoundFlutterPlugin = DetectClapSoundFlutter();
    MockDetectClapSoundFlutterPlatform fakePlatform = MockDetectClapSoundFlutterPlatform();
    DetectClapSoundFlutterPlatform.instance = fakePlatform;

    expect(await detectClapSoundFlutterPlugin.getPlatformVersion(), '42');
  });
}
