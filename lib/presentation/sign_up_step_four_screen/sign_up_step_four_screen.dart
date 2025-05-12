import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/sign_up_step_four_model.dart';
import 'provider/sign_up_step_four_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/sign_up_provider.dart';

class SignUpStepFourScreen extends StatefulWidget {
  const SignUpStepFourScreen({Key? key}) : super(key: key);

  @override
  SignUpStepFourScreenState createState() => SignUpStepFourScreenState();

  static Widget builder(BuildContext context) {
    return SignUpStepFourScreen();
  }
}

class SignUpStepFourScreenState extends State<SignUpStepFourScreen> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> initUniLinks() async {
    try {
      // Get the initial link if the app was opened with a deep link
      final initialUri = await getInitialUri();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }

      // Listen for incoming deep links while the app is running
      _sub = uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          _handleDeepLink(uri);
        }
      });
    } catch (e) {
      print('Error initializing uni_links: $e');
    }
  }

  void _handleDeepLink(Uri uri) {
    debugPrint('=== Handling deep link ===');
    debugPrint('URI: $uri');
    
    if (uri.scheme == 'moodflow') {
      if (uri.host == 'spotify-callback') {
        final code = uri.queryParameters['code'];
        if (code != null) {
          debugPrint('=== Found Spotify authorization code ===');
          final provider = Provider.of<SignUpStepFourProvider>(context, listen: false);
          provider.handleCallback(code);
        }
      } else if (uri.host == 'spotify-login') {
        final accessToken = uri.queryParameters['access_token'];
        if (accessToken != null) {
          final provider = Provider.of<SignUpStepFourProvider>(context, listen: false);
          provider.setSpotifyToken(accessToken);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: _buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Background blur overlay
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  color: Color(0xFFBCBCBC).withOpacity(0.04),
                ),
              ),
            ),
            // Top blur box
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 200.h,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Color(0xFFBCBCBC).withOpacity(0.04),
                  ),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Container(
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(horizontal: 24.h),
                          margin: EdgeInsets.only(top: 40.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 35.h),
                              Center(
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 177.h,
                                      height: 177.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 20,
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      'assets/images/spotify.svg',
                                      width: 180.h,
                                      height: 180.h,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Center(
                                child: Text(
                                  "Connect Your Soundtrack",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 26.1,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 7.h),
                              Center(
                                child: Text(
                                  "Every feeling has a rhythm.",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 7.h),
                              Center(
                                child: Text(
                                  "Connect to Spotify to save your mood's soundtrack",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 315.h,
                                      height: 75.h,
                                      margin: EdgeInsets.only(top: 20.h),
                                      padding: EdgeInsets.symmetric(vertical: 10.h),
                                      child: Consumer<SignUpStepFourProvider>(
                                        builder: (context, provider, child) {
                                          if (provider.isAuthenticated) {
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Signed in as: ",
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  provider.userEmail ?? '',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                          return GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              provider.loginWithSpotify();
                                            },
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/spotify_link.svg',
                                                  width: 315.h,
                                                  height: 55.h,
                                                  fit: BoxFit.fill,
                                                ),
                                                Text(
                                                  "Link Spotify Account",
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 24.h,
                      bottom: MediaQuery.of(context).padding.bottom + 5.h,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          // Handle next step
                    
                          Navigator.pushNamed(context, AppRoutes.finalSetUpScreen);
                        },
                        child: Container(
                          width: 130.h,
                          height: 60.h,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/next.svg',
                                width: 109.h,
                                height: 48.h,
                              ),
                              Text(
                                "Next",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 40,
      leading: Align(
        alignment: Alignment.centerLeft,
        child: _buildBackButton(),
      ),
    );
  }

  Widget _buildBackButton() {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: EdgeInsets.only(left: 12.h),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              Positioned(
                child: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
