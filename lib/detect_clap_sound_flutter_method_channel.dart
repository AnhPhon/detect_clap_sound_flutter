import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'detect_clap_sound_flutter_platform_interface.dart';

/// An implementation of [DetectClapSoundFlutterPlatform] that uses method channels.
class MethodChannelDetectClapSoundFlutter extends DetectClapSoundFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('detect_clap_sound_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
