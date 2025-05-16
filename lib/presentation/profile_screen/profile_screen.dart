import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'provider/profile_provider.dart';
import 'widgets/profile_one_item_widget.dart';

import '../../providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/app_bar.dart';
import 'package:moodflow/core/utils/size_utils.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import '../profile_my_account_screen/profile_my_account_screen.dart';
import '../../routes/app_routes.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileProvider(),
      child: ProfileScreen(),
    );
  }
}
// ...existing imports...

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

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
                children: [
                  // My Account Card
                  SizedBox(height: 24),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/My_account_widget.svg',
                        width: MediaQuery.of(context).size.width - 36,
                        fit: BoxFit.fitWidth,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Avatar
                            Consumer<UserProvider>(
                              builder: (context, userProvider, child) {
                                if (userProvider.profilePicFile != null) {
                                  return ClipOval(
                                    child: Image.file(
                                      userProvider.profilePicFile!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }
                                return Padding(
                                  padding: EdgeInsets.only(top: 3),
                                  child: SvgPicture.asset(
                                    'assets/images/person.crop.circle.fill.svg',
                                    width: 80,
                                    height: 80,
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 16),
                            // Name
                            Text(
                              provider.name ?? 'User',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Roboto',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 6),
                            // Email
                            Text(
                              provider.email ?? '',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white.withOpacity(0.85),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Roboto',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            // Account Settings Button
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.profileMyAccountScreen);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Account Settings',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.chevron_right, color: Colors.white, size: 22),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  // Settings list
                  Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/images/Settings_profile.svg',
                        width: MediaQuery.of(context).size.width - 32,
                        fit: BoxFit.fitWidth,
                      ),
                      Positioned(
                        top: 0,
                        left: 12,
                        right: 12,
                        child: SizedBox(
                          height: 270.0,
                          child: Stack(
                            children: [
                              // Daily Streak
                              Positioned(
                                top: 8,
                                left: 0,
                                right: 0,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 44,
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(left: 7),
                                      child: SvgPicture.asset(
                                        'assets/images/flame.fill 4.svg',
                                        width: 22,
                                        height: 22,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "Daily Streak",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    ),
                                    Transform.scale(
                                      scale: 0.75,
                                      child: CupertinoSwitch(
                                        value: provider.dailyStreakEnabled,
                                        onChanged: (bool value) => provider.toggleDailyStreak(value),
                                        activeColor: CupertinoColors.systemGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Gentle Reminders
                              Positioned(
                                top: 53 + 8,
                                left: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, AppRoutes.profileGentleRemindersScreen);
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 44,
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.only(left: 7),
                                        child: SvgPicture.asset(
                                          'assets/images/bell.badge.fill 1.svg',
                                          width: 22,
                                          height: 22,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          "Gentle Reminders",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.chevron_right, color: Colors.white, size: 24),
                                    ],
                                  ),
                                ),
                              ),
                              // Set PIN
                              Positioned(
                                top: 100 + 8,
                                left: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, AppRoutes.profileSetPinFirstTimeScreen);
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 44,
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.only(left: 2),
                                        child: SvgPicture.asset(
                                          'assets/images/person.badge.key.fill 1.svg',
                                          width: 28,
                                          height: 28,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          "Set PIN",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.chevron_right, color: Colors.white, size: 24),
                                    ],
                                  ),
                                ),
                              ),
                              // Accessibility
                              Positioned(
                                top: 150 + 8,
                                left: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, AppRoutes.porfileAcessibilitySettingsScreen);
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 44,
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.only(left: 7),
                                        child: SvgPicture.asset(
                                          'assets/images/Group.svg',
                                          width: 27,
                                          height: 27,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          "Accessibility",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.chevron_right, color: Colors.white, size: 24),
                                    ],
                                  ),
                                ),
                              ),
                              // Your Safety Net
                              Positioned(
                                top: 200 + 8,
                                left: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, AppRoutes.profileSafetyNetScreen);
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 44,
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.only(left: 5),
                                        child: SvgPicture.asset(
                                          'assets/images/person.3.fill 2.svg',
                                          width: 17,
                                          height: 17,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          "Your Safety Net",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.chevron_right, color: Colors.white, size: 24),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}