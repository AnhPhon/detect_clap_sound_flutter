import 'package:flutter_test/flutter_test.dart';
import 'package:detect_clap_sound_flutter/src/detect_clap_sound_flutter.dart';
import 'package:detect_clap_sound_flutter/src/detect_clap_sound_flutter_platform_interface.dart';
import 'package:detect_clap_sound_flutter/src/detect_clap_sound_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDetectClapSoundFlutterPlatform with MockPlatformInterfaceMixin implements DetectClapSoundFlutterPlatform {
  @override
  Future<bool?> getStatusPermission() => Future.value(false);

  @override
  Future<bool?> requestPermission() => Future.value(false);

  @override
  Future<String?> startRecording({String? fileName, String? path}) => Future.value(null);

  @override
  Future<String?> stopRecording() => Future.value(null);

  @override
  Stream<int> onListenDetectSound() {
    throw UnimplementedError();
  }

  @override
  Future<bool?> getStatusRecording() => Future.value(false);
}

void main() {
  final DetectClapSoundFlutterPlatform initialPlatform = DetectClapSoundFlutterPlatform.instance;

  test('$MethodChannelDetectClapSoundFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDetectClapSoundFlutter>());
  });

  test('getStatusPermission', () async {
    DetectClapSoundFlutter detectClapSoundFlutterPlugin = DetectClapSoundFlutter();
    MockDetectClapSoundFlutterPlatform fakePlatform = MockDetectClapSoundFlutterPlatform();
    DetectClapSoundFlutterPlatform.instance = fakePlatform;

    expect(detectClapSoundFlutterPlugin.getStatusPermission, true);
  });
}
