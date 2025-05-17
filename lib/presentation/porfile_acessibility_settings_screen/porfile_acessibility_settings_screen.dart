import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_switch.dart';
import 'models/porfile_acessibility_settings_model.dart';
import 'provider/porfile_acessibility_settings_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/app_bar.dart';

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
  @override
  void initState() {
    super.initState();
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
                  Stack(
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
                              padding: const EdgeInsets.only(left: 32.0),
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
                              padding: const EdgeInsets.only(right: 32.0),
                              child: Icon(Icons.chevron_right, color: Colors.white, size: 28),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
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
                              padding: const EdgeInsets.only(left: 32.0),
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
                              padding: const EdgeInsets.only(right: 32.0),
                              child: CupertinoSwitch(
                                value: context.watch<PorfileAcessibilitySettingsProvider>().isSelectedSwitch ?? false,
                                onChanged: (value) {
                                  context.read<PorfileAcessibilitySettingsProvider>().changeSwitchBox(value);
                                },
                                activeColor: CupertinoColors.systemGreen,
                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
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
                              padding: const EdgeInsets.only(left: 32.0),
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
                              padding: const EdgeInsets.only(right: 32.0),
                              child: CupertinoSwitch(
                                value: context.watch<PorfileAcessibilitySettingsProvider>().isSelectedSwitch1 ?? false,
                                onChanged: (value) {
                                  context.read<PorfileAcessibilitySettingsProvider>().changeSwitchBox1(value);
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
