import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'detect_clap_sound_flutter_method_channel.dart';

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

  Future<bool?> getStatusPermission() {
    throw UnimplementedError('getStatusPermission() has not been implemented.');
  }

  Future<bool?> requestPermission() {
    throw UnimplementedError('requestPermission() has not been implemented.');
  }

  Future<String?> startRecording({String? fileName, String? path}) {
    throw UnimplementedError('startRecording() has not been implemented.');
  }

  Future<String?> stopRecording() {
    throw UnimplementedError('startRecording() has not been implemented.');
  }

  Future<bool?> getStatusRecording() {
    throw UnimplementedError('getStatusRecording() has not been implemented.');
  }

  Stream<int> onListenDetectSound() =>
      throw UnimplementedError('onListenDetectSound not implemented on the current platform.');
}
