import 'package:detect_clap_sound_flutter/detect_clap_sound_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDetectClapSoundFlutterPlatform with MockPlatformInterfaceMixin implements DetectClapSoundFlutterPlatform {
  @override
  Future<bool?> hasPermission() => Future.value(false);

  @override
  Future<bool?> requestPermission() => Future.value(false);

  @override
  Future<String?> startRecording({String? fileName, String? path, DetectConfig? config}) => Future.value(null);

  @override
  Future<String?> stopRecording() => Future.value(null);

  @override
  Stream<int> onListenDetectSound() {
    throw UnimplementedError();
  }

  @override
  Future<bool?> isRecording() => Future.value(false);

  @override
  void dispose() {}
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

    expect(detectClapSoundFlutterPlugin.hasPermission, true);
  });
}
