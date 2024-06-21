import 'package:detect_clap_sound_flutter/detect_clap_sound_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// An implementation of [DetectClapSoundFlutterPlatform] that uses method channels.
class MethodChannelDetectClapSoundFlutter extends DetectClapSoundFlutterPlatform {
  @visibleForTesting
  final MethodChannel detectClapSoundMethodChannel = const MethodChannel(ChannelConstants.METHOD_CHANNEL_NAME);

  final EventChannel detectClapSoundEventChannel = const EventChannel(ChannelConstants.DETECT_CLAP_EVENT_CHANNEL);

  @override
  Future<bool?> hasPermission() async {
    return await detectClapSoundMethodChannel.invokeMethod<bool>(ChannelConstants.GRANTED_PERMISSION_METHOD);
  }

  @override
  Future<bool?> isRecording() async {
    return await detectClapSoundMethodChannel.invokeMethod<bool>(ChannelConstants.STATUS_RECORDING_METHOD);
  }

  @override
  Future<bool?> requestPermission() async {
    return await detectClapSoundMethodChannel.invokeMethod<bool>(ChannelConstants.REQUEST_PERMISSION_METHOD);
  }

  @override
  void startRecording({String? fileName, String? path, DetectConfig? config}) {
    detectClapSoundMethodChannel.invokeMethod(ChannelConstants.START_RECORDING_METHOD, {
      ArgumentConstants.FILE_NAME: fileName,
      ArgumentConstants.PATH_FILE: path,
      ArgumentConstants.DETECT_CONFIG: config?.createMapConfig(),
    });
  }

  @override
  Future<String?> stopRecording() async {
    return await detectClapSoundMethodChannel.invokeMethod(ChannelConstants.STOP_RECORDING_METHOD);
  }

  @override
  Stream<int> onListenDetectSound() {
    return detectClapSoundEventChannel.receiveBroadcastStream().map<int>((dynamic event) => event as int);
  }

  @override
  void dispose() {
    detectClapSoundMethodChannel.invokeMethod(ChannelConstants.DISPOSE_RECORDING_METHOD);
  }
}
