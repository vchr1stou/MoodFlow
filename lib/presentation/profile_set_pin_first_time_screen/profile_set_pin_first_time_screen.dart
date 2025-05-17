import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/profile_set_pin_first_time_model.dart';
import 'provider/profile_set_pin_first_time_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:moodflow/core/utils/size_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class ProfileSetPinFirstTimeScreen extends StatefulWidget {
  const ProfileSetPinFirstTimeScreen({Key? key}) : super(key: key);

  @override
  ProfileSetPinFirstTimeScreenState createState() =>
      ProfileSetPinFirstTimeScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileSetPinFirstTimeProvider(),
      child: const ProfileSetPinFirstTimeScreen(),
    );
  }
}

class ProfileSetPinFirstTimeScreenState
    extends State<ProfileSetPinFirstTimeScreen> {
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.email != null) {
      userProvider.fetchUserData(userProvider.email!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final bool isPinEnabled = userProvider.pinEnabled ?? false;
    
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: isPinEnabled ? 40 : 150),
                  Center(
                    child: SvgPicture.asset(
                      'assets/images/pin_person.svg',
                      width: isPinEnabled ? 85.88 : 85.88,
                      height: isPinEnabled ? 84.78 : 84.78,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Text(
                      'Set PIN',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Create a PIN to protect your personal moments.\nThis is your safe corner — a place just for you.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  if (isPinEnabled) ...[
                    SizedBox(height: 19),
                    Center(
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            'assets/images/pin_box.svg',
                            width: 340,
                            height: 184,
                          ),
                          Positioned(
                            top: 10,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Text(
                                'A PIN has been set.',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Roboto',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 40, // 10 + 15 + 8
                            left: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.profileChangePin1stStepScreen);
                              },
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/images/box2_pin.svg',
                                  width: 314,
                                  height: 64,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 104, // 40 + 64
                            left: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.profileDeletePinScreen);
                              },
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/images/box1_pin.svg',
                                  width: 314,
                                  height: 64,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 61, // 40 + 21
                            left: 32,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.profileChangePin1stStepScreen);
                              },
                              child: SvgPicture.asset(
                                'assets/images/key_fill.svg',
                                width: 13.34,
                                height: 24.55,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 64, // 40 + 24
                            left: 54.34, // 13.34 + 11
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.profileChangePin1stStepScreen);
                              },
                              child: Text(
                                'Change PIN',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 125, // 104 + 21
                            left: 32,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.profileDeletePinScreen);
                              },
                              child: SvgPicture.asset(
                                'assets/images/lock_open.svg',
                                width: 20.71,
                                height: 20.26,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 128, // 104 + 24
                            left: 54.34, // 13.34 + 11
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.profileDeletePinScreen);
                              },
                              child: Text(
                                'Delete PIN',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (!isPinEnabled) ...[
                    SizedBox(height: 19),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.profileSetNewPin1stStepScreen);
                      },
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/pin_button.svg',
                              width: 183,
                              height: 48,
                            ),
                            Text(
                              'Set a new PIN',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Handles back navigation
  void onTapArrowLeft(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.profileScreen);
  }
}
