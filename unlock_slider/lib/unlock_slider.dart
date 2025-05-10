
import 'unlock_slider_platform_interface.dart';

class UnlockSlider {
  Future<String?> getPlatformVersion() {
    return UnlockSliderPlatform.instance.getPlatformVersion();
  }
}
