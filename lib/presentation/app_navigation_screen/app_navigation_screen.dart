import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'models/app_navigation_model.dart';
import 'provider/app_navigation_provider.dart';

class AppNavigationScreen extends StatefulWidget {
  const AppNavigationScreen({Key? key})
      : super(
          key: key,
        );

  @override
  AppNavigationScreenState createState() => AppNavigationScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppNavigationProvider(),
      child: AppNavigationScreen(),
    );
  }
}

class AppNavigationScreenState extends State<AppNavigationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFFFFFF),
      body: SafeArea(
        child: SizedBox(
          width: 375.h,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0XFFFFFFFF),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: Text(
                        "App Navigation",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0XFF000000),
                          fontSize: 20.fSize,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.only(left: 20.h),
                      child: Text(
                        "Check your app's UI from the below demo screens of your app.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0XFF888888),
                          fontSize: 16.fSize,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Divider(
                      height: 1.h,
                      thickness: 1.h,
                      color: Color(0XFF000000),
                    )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0XFFFFFFFF),
                    ),
                    child: Column(
                      children: [
                        _buildScreenTitle(
                          context,
                          screenTitle: "Discover",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.discoverScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "HomeScreen",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.homescreenScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Streak Screen",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.streakScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "AI Screen",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.aiScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Log Input Screen",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.logInputScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Log Input Colors",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.logInputColorsScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Log Input AI",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.logInputAiScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Logged Input AI",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.loggedInputAiScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Emoji Log - One",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.emojiLogOneScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Emoji Log - Two",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.emojiLogTwoScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Emoji Log - Three",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.emojiLogThreeScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Emoji Log - Four",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.emojiLogFourScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Emoji Log - Five",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.emojiLogFiveScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Profile",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.profileScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Porfile - Acessibility Settings",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.porfileAcessibilitySettingsScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Profile - Gentle Reminders",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.profileGentleRemindersScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Profile - Safety Net",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.profileSafetyNetScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Profile - My account",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.profileMyAccountScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Profile - Spotify",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.profileSpotifyScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Welcome Screen",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.welcomeScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Login",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.loginScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Sign Up - Step One",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.signUpStepOneScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Sign Up - Step Two",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.signUpStepTwoScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Sign Up - Step Three",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.signUpStepThreeScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Sign Up - Step 3 Filled",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.signUpStep3FilledScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Sign Up -Step Four",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.signUpStepFourScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Final Set Up Screen ",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.finalSetUpScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Little Lifts",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.littleLiftsScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Movies",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.moviesScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Book",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.bookScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Cooking",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.cookingScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "SafetyNetLittleLifts",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.safetynetlittleliftsScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Saved",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.savedScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Saved Preview",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.savedPreviewScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "BreathingMain",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.breathingmainScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Inhale",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.inhaleScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "BreathingDone",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.breathingdoneScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Log Screen",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.logScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Log Screen - Step 2 - Positive",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.logScreenStep2PositiveScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Log Screen - Step 3 - Positive",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.logScreenStep3PositiveScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Log Screen - Step Four",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.logScreenStepFourScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Log Screen - Step Five",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.logScreenStepFiveScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Log Screen - Step 3 - No Positive",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.logScreenStep3NoPositiveScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Forgot Password",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.forgotPasswordScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Reset Password",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.resetPasswordScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Profile - Set PIN first time",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.profileSetPinFirstTimeScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Profile - PIN setted",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.profilePinSettedScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Profile - Change PIN - 1st step",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.profileChangePin1stStepScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Profile - Change PIN - 2nd step",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.profileChangePin2ndStepScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Profile - Set new PIN - 2nd step",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.profileSetNewPin2ndStepScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Profile - Set new PIN - 1st step",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.profileSetNewPin1stStepScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Meditation",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.meditationScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Traveling",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.travelingScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Music",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.musicScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "PositiveAffirmations",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.positiveaffirmationsScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Workout",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.workoutScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "SoftThanks",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.softthanksScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "BeneathLittleLifts - One",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.beneathlittleliftsOneScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "BeneathLittleLifts - Two",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.beneathlittleliftsTwoScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "BeneathLittleLifts - Three",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.beneathlittleliftsThreeScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Profile - Delete PIN",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.profileDeletePinScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "HIstory Empty",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.historyEmptyScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "History Filled",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.historyFilledScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "History Preview",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.historyPreviewScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Statistics - Mood Charts",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.statisticsMoodChartsScreen),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Common widget
  Widget _buildScreenTitle(
    BuildContext context, {
    required String screenTitle,
    Function? onTapScreenTitle,
  }) {
    return GestureDetector(
      onTap: () {
        onTapScreenTitle?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0XFFFFFFFF),
        ),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Text(
                screenTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF000000),
                  fontSize: 20.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(height: 5.h),
            Divider(
              height: 1.h,
              thickness: 1.h,
              color: Color(0XFF888888),
            )
          ],
        ),
      ),
    );
  }

  /// Common navigate
  void onTapScreenTitle(String routeName) {
    Navigator.pushNamed(context, routeName);
  }
}
