import 'package:flutter_test/flutter_test.dart';
import 'package:unlock_slider/unlock_slider.dart';
import 'package:unlock_slider/unlock_slider_platform_interface.dart';
import 'package:unlock_slider/unlock_slider_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockUnlockSliderPlatform
    with MockPlatformInterfaceMixin
    implements UnlockSliderPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final UnlockSliderPlatform initialPlatform = UnlockSliderPlatform.instance;

  test('$MethodChannelUnlockSlider is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelUnlockSlider>());
  });

  test('getPlatformVersion', () async {
    UnlockSlider unlockSliderPlugin = UnlockSlider();
    MockUnlockSliderPlatform fakePlatform = MockUnlockSliderPlatform();
    UnlockSliderPlatform.instance = fakePlatform;

    expect(await unlockSliderPlugin.getPlatformVersion(), '42');
  });
}
