import 'detect_clap_sound_flutter_platform_interface.dart';

class DetectClapSoundFlutter {
  /// [getStatusPermission] to get status record permissions.
  /// The return value is of type bool.
  /// If granted then return true.
  /// This function only get status and does not require permission.
  Future<bool?> getStatusPermission() {
    return DetectClapSoundFlutterPlatform.instance.getStatusPermission();
  }

  /// [getStatusRecording] to get status recording.
  /// The return value is of type bool.
  /// True is recording, false is stop recording.
  Future<bool?> getStatusRecording() {
    return DetectClapSoundFlutterPlatform.instance.getStatusRecording();
  }

  /// [requestPermission] to request permission.
  /// The return value is of type bool.
  /// When permission is granted then return true.
  Future<bool?> requestPermission() {
    return DetectClapSoundFlutterPlatform.instance.requestPermission();
  }

  /// [startRecording] to start recording.
  /// User can set File name and File path.
  /// The audio file will be saved in 3gp format.
  /// Aims to optimize capacity because the Plugin is only for sound recognition purposes.
  Future<String?> startRecording({String? fileName, String? path}) {
    return DetectClapSoundFlutterPlatform.instance.startRecording(fileName: fileName, path: path);
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
}
