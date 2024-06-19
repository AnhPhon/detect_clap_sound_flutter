import 'package:detect_clap_sound_flutter/detect_clap_sound_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// An implementation of [DetectClapSoundFlutterPlatform] that uses method channels.
class MethodChannelDetectClapSoundFlutter extends DetectClapSoundFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final MethodChannel detectClapSoundMethodChannel = const MethodChannel(ChannelConstants.METHOD_CHANNEL_NAME);

  final EventChannel detectClapSoundEventChannel = const EventChannel(ChannelConstants.DETECT_CLAP_EVENT_CHANNEL);

  @override
  Future<bool?> getStatusPermission() async {
    return await detectClapSoundMethodChannel.invokeMethod<bool>(ChannelConstants.GRANTED_PERMISSION_METHOD);
  }

  @override
  Future<bool?> getStatusRecording() async {
    return await detectClapSoundMethodChannel.invokeMethod<bool>(ChannelConstants.STATUS_RECORDING_METHOD);
  }

  @override
  Future<bool?> requestPermission() async {
    return await detectClapSoundMethodChannel.invokeMethod<bool>(ChannelConstants.REQUEST_PERMISSION_METHOD);
  }

  @override
  Future<String?> startRecording({String? fileName, String? path}) async {
    return await detectClapSoundMethodChannel.invokeMethod(ChannelConstants.START_RECORDING_METHOD, {
      ArgumentConstants.FILE_NAME: fileName,
      ArgumentConstants.PATH_FILE: path,
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
}
