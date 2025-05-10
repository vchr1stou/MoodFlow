import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'unlock_slider_method_channel.dart';

abstract class UnlockSliderPlatform extends PlatformInterface {
  /// Constructs a UnlockSliderPlatform.
  UnlockSliderPlatform() : super(token: _token);

  static final Object _token = Object();

  static UnlockSliderPlatform _instance = MethodChannelUnlockSlider();

  /// The default instance of [UnlockSliderPlatform] to use.
  ///
  /// Defaults to [MethodChannelUnlockSlider].
  static UnlockSliderPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [UnlockSliderPlatform] when
  /// they register themselves.
  static set instance(UnlockSliderPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
