import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_export.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import '../little_lifts_screen/little_lifts_screen.dart';
import 'provider/safetynetlittlelifts_provider.dart';

class SafetynetlittleliftsScreen extends StatefulWidget {
  const SafetynetlittleliftsScreen({Key? key}) : super(key: key);

  @override
  SafetynetlittleliftsScreenState createState() =>
      SafetynetlittleliftsScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SafetynetlittleliftsProvider(),
      child: const SafetynetlittleliftsScreen(),
    );
  }
}

class SafetynetlittleliftsScreenState extends State<SafetynetlittleliftsScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SafetynetlittleliftsProvider>(context);
    
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => LittleLiftsScreen.builder(context),
          ),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: _buildAppbar(context),
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.cover,
                  ),
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
            // Main content
            SafeArea(
              child: Stack(
                children: [
                  // Chat messages (show only the welcome message)
                  if (provider.showChat && provider.messages.isNotEmpty)
                    Positioned(
                      top: 0.h,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.transparent,
                        child: SingleChildScrollView(
                          reverse: false,
                          padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (provider.messages.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(bottom: 12),
                                  child: Column(
                                    children: [
                                      BubbleSpecialThree(
                                        text: provider.messages[0]['content'] ?? '',
                                        color: Color(0xFFF5B9EA).withOpacity(0.3),
                                        tail: true,
                                        isSender: false,
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
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
                  // Safety net box SVG with call overlays
                  if (provider.isInitialized &&
                      !provider.safetynetlittleliftsModelObj.isLoading &&
                      (provider.safetynetlittleliftsModelObj.safetynetFileCount == 4 || 
                       provider.safetynetlittleliftsModelObj.safetynetFileCount == 3 ||
                       provider.safetynetlittleliftsModelObj.safetynetFileCount == 2 ||
                       provider.safetynetlittleliftsModelObj.safetynetFileCount == 1))
                    Positioned(
                      bottom: provider.safetynetlittleliftsModelObj.safetynetFileCount == 4 
                          ? 195.h
                          : provider.safetynetlittleliftsModelObj.safetynetFileCount == 3
                              ? 275.h
                              : provider.safetynetlittleliftsModelObj.safetynetFileCount == 2
                                  ? 355.h
                                  : 435.h,
                      left: 0,
                      right: 0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Main safety net box
                          SvgPicture.asset(
                            provider.safetynetlittleliftsModelObj.safetynetFileCount == 4 
                                ? 'assets/images/call_svg_4.svg'
                                : provider.safetynetlittleliftsModelObj.safetynetFileCount == 3
                                    ? 'assets/images/sn_call_3.svg'
                                    : provider.safetynetlittleliftsModelObj.safetynetFileCount == 2
                                        ? 'assets/images/sn_call_2.svg'
                                        : 'assets/images/call_sn_1.svg',
                            width: provider.safetynetlittleliftsModelObj.safetynetFileCount == 4 
                                ? 366.h
                                : provider.safetynetlittleliftsModelObj.safetynetFileCount == 3
                                    ? 366.h
                                    : provider.safetynetlittleliftsModelObj.safetynetFileCount == 2
                                        ? 366.h
                                        : 366.h,
                            height: provider.safetynetlittleliftsModelObj.safetynetFileCount == 4 
                                ? 374.h
                                : provider.safetynetlittleliftsModelObj.safetynetFileCount == 3
                                    ? 294.h
                                    : provider.safetynetlittleliftsModelObj.safetynetFileCount == 2
                                        ? 214.h
                                        : 134.h,
                          ),
                          // First call overlay with contact info
                          Positioned(
                            top: 35.h,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Call SVG
                                SvgPicture.asset(
                                  'assets/images/call_sn.svg',
                                  width: 333.h,
                                  height: 64.h,
                                ),
                                // Contact info
                                if (provider.safetynetlittleliftsModelObj.contactDebugInfo != null)
                                  Builder(
                                    builder: (context) {
                                      final contactInfo = provider.safetynetlittleliftsModelObj.contactDebugInfo!['person1'];
                                      if (contactInfo == null) return SizedBox.shrink();
                                      
                                      return Positioned(
                                        top: 11.h,
                                        left: 20.h,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 20.h,
                                              backgroundImage: contactInfo['avatarData'] != null
                                                  ? MemoryImage(contactInfo['avatarData'])
                                                  : null,
                                              child: contactInfo['avatarData'] == null
                                                  ? Text(
                                                      contactInfo['name']?.substring(0, 1).toUpperCase() ?? '?',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                            SizedBox(width: 11.h),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  contactInfo['name'] ?? 'Unknown',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.h,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Transform.translate(
                                                  offset: Offset(0, -2.h),
                                                  child: Text(
                                                    contactInfo['phone'] ?? 'No phone number',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.h,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                // Call button overlay
                                Positioned(
                                  right: 20.h,
                                  top: 17.h,
                                  child: GestureDetector(
                                    onTap: () async {
                                      final phoneNumber = provider.safetynetlittleliftsModelObj.contactDebugInfo?['person1']?['phone'];
                                      if (phoneNumber != null) {
                                        final Uri phoneUri = Uri(
                                          scheme: 'tel',
                                          path: phoneNumber.replaceAll(RegExp(r'[^0-9+]'), ''),
                                        );
                                        if (await canLaunchUrl(phoneUri)) {
                                          await launchUrl(phoneUri);
                                        }
                                      }
                                    },
                                    child: Stack(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/call.svg',
                                          width: 68.h,
                                          height: 30.h,
                                        ),
                                        Positioned(
                                          left: 14.5.h,
                                          top: 0,
                                          bottom: 0,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              'assets/images/call_icon.svg',
                                              width: 14.h,
                                              height: 14.h,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 31.h,
                                          top: 0,
                                          bottom: 0,
                                          child: Center(
                                            child: Text(
                                              'Call',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Second call overlay - only show if safetynetFileCount is 2 or more
                          if (provider.safetynetlittleliftsModelObj.safetynetFileCount >= 2)
                            Positioned(
                              top: 115.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/call_sn.svg',
                                    width: 333.h,
                                    height: 64.h,
                                  ),
                                  // Contact info
                                  if (provider.safetynetlittleliftsModelObj.contactDebugInfo != null)
                                    Builder(
                                      builder: (context) {
                                        final contactInfo = provider.safetynetlittleliftsModelObj.contactDebugInfo!['person2'];
                                        if (contactInfo == null) return SizedBox.shrink();
                                        
                                        return Positioned(
                                          top: 11.h,
                                          left: 20.h,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 20.h,
                                                backgroundImage: contactInfo['avatarData'] != null
                                                    ? MemoryImage(contactInfo['avatarData'])
                                                    : null,
                                                child: contactInfo['avatarData'] == null
                                                    ? Text(
                                                        contactInfo['name']?.substring(0, 1).toUpperCase() ?? '?',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                              SizedBox(width: 11.h),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    contactInfo['name'] ?? 'Unknown',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.h,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Transform.translate(
                                                    offset: Offset(0, -2.h),
                                                    child: Text(
                                                      contactInfo['phone'] ?? 'No phone number',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.h,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  // Call button overlay
                                  Positioned(
                                    right: 20.h,
                                    top: 17.h,
                                    child: GestureDetector(
                                      onTap: () async {
                                        final phoneNumber = provider.safetynetlittleliftsModelObj.contactDebugInfo?['person2']?['phone'];
                                        if (phoneNumber != null) {
                                          final Uri phoneUri = Uri(
                                            scheme: 'tel',
                                            path: phoneNumber.replaceAll(RegExp(r'[^0-9+]'), ''),
                                          );
                                          if (await canLaunchUrl(phoneUri)) {
                                            await launchUrl(phoneUri);
                                          }
                                        }
                                      },
                                      child: Stack(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/call.svg',
                                            width: 68.h,
                                            height: 30.h,
                                          ),
                                          Positioned(
                                            left: 14.5.h,
                                            top: 0,
                                            bottom: 0,
                                            child: Center(
                                              child: SvgPicture.asset(
                                                'assets/images/call_icon.svg',
                                                width: 14.h,
                                                height: 14.h,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 31.h,
                                            top: 0,
                                            bottom: 0,
                                            child: Center(
                                              child: Text(
                                                'Call',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // Third call overlay - only show if safetynetFileCount is 3 or 4
                          if (provider.safetynetlittleliftsModelObj.safetynetFileCount >= 3)
                            Positioned(
                              top: 195.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/call_sn.svg',
                                    width: 333.h,
                                    height: 64.h,
                                  ),
                                  // Contact info
                                  if (provider.safetynetlittleliftsModelObj.contactDebugInfo != null)
                                    Builder(
                                      builder: (context) {
                                        final contactInfo = provider.safetynetlittleliftsModelObj.contactDebugInfo!['person3'];
                                        if (contactInfo == null) return SizedBox.shrink();
                                        
                                        return Positioned(
                                          top: 11.h,
                                          left: 20.h,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 20.h,
                                                backgroundImage: contactInfo['avatarData'] != null
                                                    ? MemoryImage(contactInfo['avatarData'])
                                                    : null,
                                                child: contactInfo['avatarData'] == null
                                                    ? Text(
                                                        contactInfo['name']?.substring(0, 1).toUpperCase() ?? '?',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                              SizedBox(width: 11.h),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    contactInfo['name'] ?? 'Unknown',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.h,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Transform.translate(
                                                    offset: Offset(0, -2.h),
                                                    child: Text(
                                                      contactInfo['phone'] ?? 'No phone number',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.h,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  // Call button overlay
                                  Positioned(
                                    right: 20.h,
                                    top: 17.h,
                                    child: GestureDetector(
                                      onTap: () async {
                                        final phoneNumber = provider.safetynetlittleliftsModelObj.contactDebugInfo?['person3']?['phone'];
                                        if (phoneNumber != null) {
                                          final Uri phoneUri = Uri(
                                            scheme: 'tel',
                                            path: phoneNumber.replaceAll(RegExp(r'[^0-9+]'), ''),
                                          );
                                          if (await canLaunchUrl(phoneUri)) {
                                            await launchUrl(phoneUri);
                                          }
                                        }
                                      },
                                      child: Stack(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/call.svg',
                                            width: 68.h,
                                            height: 30.h,
                                          ),
                                          Positioned(
                                            left: 14.5.h,
                                            top: 0,
                                            bottom: 0,
                                            child: Center(
                                              child: SvgPicture.asset(
                                                'assets/images/call_icon.svg',
                                                width: 14.h,
                                                height: 14.h,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 31.h,
                                            top: 0,
                                            bottom: 0,
                                            child: Center(
                                              child: Text(
                                                'Call',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // Fourth call overlay - only show if safetynetFileCount is 4
                          if (provider.safetynetlittleliftsModelObj.safetynetFileCount == 4)
                            Positioned(
                              top: 275.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/call_sn.svg',
                                    width: 333.h,
                                    height: 64.h,
                                  ),
                                  // Contact info
                                  if (provider.safetynetlittleliftsModelObj.contactDebugInfo != null)
                                    Builder(
                                      builder: (context) {
                                        final contactInfo = provider.safetynetlittleliftsModelObj.contactDebugInfo!['person4'];
                                        if (contactInfo == null) return SizedBox.shrink();
                                        
                                        return Positioned(
                                          top: 11.h,
                                          left: 20.h,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 20.h,
                                                backgroundImage: contactInfo['avatarData'] != null
                                                    ? MemoryImage(contactInfo['avatarData'])
                                                    : null,
                                                child: contactInfo['avatarData'] == null
                                                    ? Text(
                                                        contactInfo['name']?.substring(0, 1).toUpperCase() ?? '?',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                              SizedBox(width: 11.h),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    contactInfo['name'] ?? 'Unknown',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.h,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Transform.translate(
                                                    offset: Offset(0, -2.h),
                                                    child: Text(
                                                      contactInfo['phone'] ?? 'No phone number',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.h,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  // Call button overlay
                                  Positioned(
                                    right: 20.h,
                                    top: 17.h,
                                    child: GestureDetector(
                                      onTap: () async {
                                        final phoneNumber = provider.safetynetlittleliftsModelObj.contactDebugInfo?['person4']?['phone'];
                                        if (phoneNumber != null) {
                                          final Uri phoneUri = Uri(
                                            scheme: 'tel',
                                            path: phoneNumber.replaceAll(RegExp(r'[^0-9+]'), ''),
                                          );
                                          if (await canLaunchUrl(phoneUri)) {
                                            await launchUrl(phoneUri);
                                          }
                                        }
                                      },
                                      child: Stack(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/call.svg',
                                            width: 68.h,
                                            height: 30.h,
                                          ),
                                          Positioned(
                                            left: 14.5.h,
                                            top: 0,
                                            bottom: 0,
                                            child: Center(
                                              child: SvgPicture.asset(
                                                'assets/images/call_icon.svg',
                                                width: 14.h,
                                                height: 14.h,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 31.h,
                                            top: 0,
                                            bottom: 0,
                                            child: Center(
                                              child: Text(
                                                'Call',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    )
                  else if (provider.isInitialized && !provider.safetynetlittleliftsModelObj.isLoading)
                    Positioned(
                      top: 174.h,
                      left: 0,
                      right: 0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/sign_up_safety_net_empty.svg',
                            width: 340.h,
                            height: 223.h,
                          ),
                          Positioned(
                            top: 48.h,
                            child: Text(
                              "Add a Trusted Contact",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.profileSafetyNetScreen);
                              },
                              child: SvgPicture.asset(
                                'assets/images/sign_up_safety_net_plus.svg',
                                width: 58.88.h,
                                height: 57.1.h,
                              ),
                            ),
                          ),
                        ],
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

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 200.h,
      leading: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => LittleLiftsScreen.builder(context),
                ),
                (route) => false,
              );
            },
            child: Padding(
              padding: EdgeInsets.only(left: 16.h, top: 10.h),
              child: SvgPicture.asset(
                'assets/images/back_log.svg',
                width: 27.h,
                height: 27.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
