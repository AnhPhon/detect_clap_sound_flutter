
import 'detect_clap_sound_flutter_platform_interface.dart';

class DetectClapSoundFlutter {
  Future<String?> getPlatformVersion() {
    return DetectClapSoundFlutterPlatform.instance.getPlatformVersion();
  }
}
