import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'unlock_slider_platform_interface.dart';

/// An implementation of [UnlockSliderPlatform] that uses method channels.
class MethodChannelUnlockSlider extends UnlockSliderPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('unlock_slider');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
