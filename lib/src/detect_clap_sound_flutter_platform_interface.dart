import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../detect_clap_sound_flutter.dart';

abstract class DetectClapSoundFlutterPlatform extends PlatformInterface {
  /// Constructs a DetectClapSoundFlutterPlatform.
  DetectClapSoundFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static DetectClapSoundFlutterPlatform _instance = MethodChannelDetectClapSoundFlutter();

  /// The default instance of [DetectClapSoundFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelDetectClapSoundFlutter].
  static DetectClapSoundFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DetectClapSoundFlutterPlatform] when
  /// they register themselves.
  static set instance(DetectClapSoundFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> hasPermission() {
    throw UnimplementedError('hasPermission() has not been implemented.');
  }

  Future<bool?> requestPermission() {
    throw UnimplementedError('requestPermission() has not been implemented.');
  }

  void startRecording({String? fileName, String? path, DetectConfig? config}) {
    throw UnimplementedError('startRecording() has not been implemented.');
  }

  Future<String?> stopRecording() {
    throw UnimplementedError('startRecording() has not been implemented.');
  }

  Future<bool?> isRecording() {
    throw UnimplementedError('isRecording() has not been implemented.');
  }

  Stream<int> onListenDetectSound() {
    throw UnimplementedError('onListenDetectSound not implemented on the current platform.');
  }

  void dispose() {
    throw UnimplementedError('dispose() has not been implemented.');
  }
}
