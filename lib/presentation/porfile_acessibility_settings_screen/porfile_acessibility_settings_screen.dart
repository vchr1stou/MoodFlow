import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_settings/app_settings.dart';
import 'dart:io' show Platform;
import '../../core/app_export.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_switch.dart';
import 'models/porfile_acessibility_settings_model.dart';
import 'provider/porfile_acessibility_settings_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/app_bar.dart';
import '../../providers/accessibility_provider.dart';

class PorfileAcessibilitySettingsScreen extends StatefulWidget {
  const PorfileAcessibilitySettingsScreen({Key? key}) : super(key: key);

  @override
  PorfileAcessibilitySettingsScreenState createState() =>
      PorfileAcessibilitySettingsScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PorfileAcessibilitySettingsProvider(),
      child: PorfileAcessibilitySettingsScreen(),
    );
  }
}

class PorfileAcessibilitySettingsScreenState
    extends State<PorfileAcessibilitySettingsScreen> {
  Future<void> _openAccessibilitySettings() async {
    try {
      if (Platform.isIOS) {
        // iOS accessibility settings
        await AppSettings.openAppSettings();
      } else if (Platform.isAndroid) {
        // Android accessibility settings
        const platform = MethodChannel('app_settings');
        await platform.invokeMethod('openAccessibilitySettings');
      }
    } catch (e) {
      debugPrint('Error opening accessibility settings: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize the switch state from the accessibility provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PorfileAcessibilitySettingsProvider>().initialize(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: buildAppbar(context),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Top icon (Group.svg)
                  SvgPicture.asset(
                    'assets/images/Group.svg',
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Accessibility',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Voice Over (top_my_account.svg)
                  GestureDetector(
                    onTap: _openAccessibilitySettings,
                    child: Stack(
                      children: [
                        SvgPicture.asset(
                          'assets/images/top_my_account.svg',
                          width: MediaQuery.of(context).size.width - 32,
                          fit: BoxFit.fitWidth,
                        ),
                        Positioned.fill(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 24.0),
                                child: Text(
                                  'Voice Over',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 30.0),
                                child: SvgPicture.asset(
                                  'assets/images/chevron_right_profile.svg',
                                  width: 15.04,
                                  height: 18.18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Invert Colors (medium_my_account.svg)
                  Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/images/medium_my_account.svg',
                        width: MediaQuery.of(context).size.width - 32,
                        fit: BoxFit.fitWidth,
                      ),
                      Positioned.fill(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: Text(
                                'Invert Colors',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 24.0),
                              child: CupertinoSwitch(
                                value: context.watch<PorfileAcessibilitySettingsProvider>().isSelectedSwitch,
                                onChanged: (value) {
                                  context.read<PorfileAcessibilitySettingsProvider>().changeSwitchBox(value, context);
                                },
                                activeColor: CupertinoColors.systemGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Larger Text (bottom_my_account.svg)
                  Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/images/bottom_my_account.svg',
                        width: MediaQuery.of(context).size.width - 32,
                        fit: BoxFit.fitWidth,
                      ),
                      Positioned.fill(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: Text(
                                'Larger Text',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 24.0),
                              child: CupertinoSwitch(
                                value: context.watch<PorfileAcessibilitySettingsProvider>().isSelectedSwitch1,
                                onChanged: (value) {
                                  context.read<PorfileAcessibilitySettingsProvider>().changeSwitchBox1(value, context);
                                },
                                activeColor: CupertinoColors.systemGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Navigates to the previous screen.
  void onTapBtnArrowleftone(BuildContext context) {
    NavigatorService.goBackWithoutContext();
  }
}
