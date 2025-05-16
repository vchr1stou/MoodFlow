import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/profile_my_account_model.dart';
import 'provider/profile_my_account_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/app_bar.dart';

import '../../providers/user_provider.dart';

class ProfileMyAccountScreen extends StatefulWidget {
  const ProfileMyAccountScreen({Key? key}) : super(key: key);

  @override
  ProfileMyAccountScreenState createState() => ProfileMyAccountScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileMyAccountProvider(),
      child: ProfileMyAccountScreen(),
    );
  }
}

class ProfileMyAccountScreenState extends State<ProfileMyAccountScreen> {
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
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Column(
              children: [
                SizedBox(height: 32),
                // Main My Account Card
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: SvgPicture.asset(
                        'assets/images/my_account_page_widget.svg',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Avatar
                          const CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.emoji_emotions, size: 56, color: Colors.orange), // Replace with user avatar if available
                          ),
                          const SizedBox(height: 12),
                          // Edit Button
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/edit_widget.svg',
                                width: 126,
                                height: 30,
                                fit: BoxFit.contain,
                              ),
                              const Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          // Name Row
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/top_my_account.svg',
                                width: double.infinity,
                                fit: BoxFit.fill,
                                height: 54,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25.0, right: 20.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Name',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    Spacer(),
                                    const Text(
                                      'Vasillis Christou',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(Icons.chevron_right, color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Pronouns Row
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/medium_my_account.svg',
                                width: double.infinity,
                                fit: BoxFit.fill,
                                height: 54,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25.0, right: 20.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Pronouns',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    Spacer(),
                                    const Text(
                                      'He/him',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(Icons.chevron_right, color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Email Row
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/medium_my_account.svg',
                                width: double.infinity,
                                fit: BoxFit.fill,
                                height: 54,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25.0, right: 20.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      'E-mail',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    Spacer(),
                                    const Text(
                                      'vchristou@gmail.com',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(Icons.chevron_right, color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Password Row
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/bottom_my_account.svg',
                                width: double.infinity,
                                fit: BoxFit.fill,
                                height: 54,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25.0, right: 20.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Password',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    Spacer(),
                                    const Text(
                                      '•••••••',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(Icons.chevron_right, color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                // Sign Out Button
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/sign_out.svg',
                      width: 190,
                      height: 44,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
          )
    );
  }

}
