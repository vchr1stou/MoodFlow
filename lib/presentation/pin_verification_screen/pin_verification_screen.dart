import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import '../../providers/user_provider.dart';
import '../../core/app_export.dart';
import '../../core/utils/size_utils.dart';
import '../../services/auth_persistence_service.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({Key? key}) : super(key: key);

  @override
  PinVerificationScreenState createState() => PinVerificationScreenState();

  static Widget builder(BuildContext context) {
    return const PinVerificationScreen();
  }
}

class PinVerificationScreenState extends State<PinVerificationScreen> {
  String pin = '';
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _pinController.addListener(() {
      if (_pinController.text.length > 4) {
        _pinController.text = _pinController.text.substring(0, 4);
      }
      setState(() {
        pin = _pinController.text;
      });
    });
    _initializeUserProvider();
  }

  Future<void> _initializeUserProvider() async {
    try {
      final savedCredentials = await AuthPersistenceService.getSavedCredentials();
      if (savedCredentials != null && savedCredentials['email'] != null) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.email = savedCredentials['email'];
        await userProvider.fetchUserData(savedCredentials['email']!);
      }
    } catch (e) {
      print('Error initializing user provider: $e');
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  Future<void> _verifyPin() async {
    print('Verifying PIN...'); // Debug print
    if (pin.length != 4) {
      print('PIN length is not 4: ${pin.length}'); // Debug print
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    print('User email: ${userProvider.email}'); // Debug print
    
    if (userProvider.email != null) {
      try {
        print('Fetching user document...'); // Debug print
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userProvider.email)
            .get();
        
        print('User document exists: ${userDoc.exists}'); // Debug print
        print('Stored PIN: ${userDoc.data()?['pin']}'); // Debug print
        print('Entered PIN: $pin'); // Debug print
        
        if (userDoc.exists && userDoc.data()?['pin'] == pin) {
          print('PIN matches, navigating to home screen...'); // Debug print
          // PIN matches, navigate to home screen
          if (mounted) {
            Navigator.pushReplacementNamed(context, AppRoutes.homescreenScreen);
          }
        } else {
          print('PIN does not match'); // Debug print
          // PIN doesn't match
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Incorrect PIN. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
            setState(() {
              _pinController.clear();
              pin = '';
            });
          }
        }
      } catch (e) {
        print('Error verifying PIN: $e'); // Debug print
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error verifying PIN: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      print('User email is null'); // Debug print
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Image
          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay with blur
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Color(0xFF000000).withOpacity(0.15),
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Center(
              child: Container(
                width: 340.h,
                margin: EdgeInsets.symmetric(horizontal: 16.h),
                decoration: BoxDecoration(
                  color: Color(0xFFBCBCBC).withOpacity(0.04),
                  borderRadius: BorderRadius.circular(24.h),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.h,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.h),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: EdgeInsets.all(24.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 12.h),
                          Container(
                            width: 40.h,
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(2.h),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            "Enter PIN",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            "Please enter your PIN to continue",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          GestureDetector(
                            onTap: () {
                              _pinFocusNode.requestFocus();
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/pin_verification_input.svg',
                                  width: 336,
                                  height: 66,
                                ),
                                Container(
                                  height: 66,
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(4, (index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Text(
                                          index < _pinController.text.length ? '•' : '_',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            height: 1,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                Opacity(
                                  opacity: 0,
                                  child: TextField(
                                    controller: _pinController,
                                    focusNode: _pinFocusNode,
                                    keyboardType: TextInputType.number,
                                    maxLength: 4,
                                    style: TextStyle(color: Colors.transparent),
                                    decoration: InputDecoration(
                                      counterText: '',
                                      border: InputBorder.none,
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                          GestureDetector(
                            onTap: _verifyPin,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/pin_verification_button.svg',
                                  width: 183,
                                  height: 48,
                                ),
                                Text(
                                  "Verify PIN",
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
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 