import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/profile_set_pin_first_time_model.dart';
import 'provider/profile_set_pin_first_time_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:moodflow/core/utils/size_utils.dart';

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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 24),
                  // Your content will go here
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
    NavigatorService.goBackWithoutContext();
  }
}
