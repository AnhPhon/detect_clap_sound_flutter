import 'package:detect_clap_sound_flutter/detect_clap_sound_flutter.dart';

class DetectClapSoundFlutter {
  /// [hasPermission] to get status record permissions.
  /// The return value is of type bool.
  /// If granted then return true.
  /// This function only get status and does not require permission.
  Future<bool?> hasPermission() {
    return DetectClapSoundFlutterPlatform.instance.hasPermission();
  }

  /// [isRecording] to get status recording.
  /// The return value is of type bool.
  /// True is recording, false is stop recording.
  Future<bool?> isRecording() {
    return DetectClapSoundFlutterPlatform.instance.isRecording();
  }

  /// [requestPermission] to request permission.
  /// The return value is of type bool.
  /// When permission is granted then return true.
  Future<bool?> requestPermission() {
    return DetectClapSoundFlutterPlatform.instance.requestPermission();
  }

  /// [startRecording] to start recording.
  /// 
  /// User can set [fileName] and [path].
  /// 
  /// The audio file will be saved in 3gp format.
  /// Aims to optimize capacity because the Plugin is only for sound recognition purposes.
  /// 
  /// Set [config] with:
  /// 
  /// [config.threshold] Minimum amplitude threshold to identify a sound as possible.
  /// 
  /// [config.stableThreshold] Threshold to determine when the amplitude has returned to a stable level, helping to prevent repeated detection.
  /// 
  /// [config.amplitudeSpikeThreshold] Threshold to determine the sudden change in amplitude (difference between largest and smallest amplitude), which characterizes applause.
  /// 
  /// [config.windowSize] Number of amplitude samples in the test window.
  /// 
  /// [config.monitorInterval] Interval between amplitude checks.
  void startRecording({String? fileName, String? path, DetectConfig? config}) {
    DetectClapSoundFlutterPlatform.instance.startRecording(fileName: fileName, path: path, config: config);
  }

  /// [stopRecording] to stop recording.
  /// The return value is the audio file path.
  Future<String?> stopRecording() {
    return DetectClapSoundFlutterPlatform.instance.stopRecording();
  }

  /// [onListenDetectSound] to listen and detect the sound.
  /// If sound is detected, an int data value of 1 unit will be fired.
  Stream<int> onListenDetectSound() {
    return DetectClapSoundFlutterPlatform.instance.onListenDetectSound();
  }

  /// [dispose] to dispose the recorder.
  void dispose() {
    DetectClapSoundFlutterPlatform.instance.dispose();
  }
}
