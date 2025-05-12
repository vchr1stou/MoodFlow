import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_export.dart';
import '../little_lifts_screen/little_lifts_screen.dart';
import 'provider/softthanks_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/user_service.dart';

class SoftthanksScreen extends StatefulWidget {
  const SoftthanksScreen({Key? key}) : super(key: key);

  @override
  SoftthanksScreenState createState() => SoftthanksScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SoftthanksProvider(),
      child: const SoftthanksScreen(),
    );
  }
}

class SoftthanksScreenState extends State<SoftthanksScreen> {
  final UserService _userService = UserService();
  String? userEmail;
  bool _isInitialized = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    print('SoftthanksScreen initialized');
    _scrollController.addListener(() {
      setState(() {}); // This will rebuild the overlay when scrolling
    });
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    try {
      final userData = await _userService.getCurrentUserData();
      setState(() {
        userEmail = userData?['email'];
        _isInitialized = true;
      });
    } catch (e) {
      print('Error loading user email: $e');
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Building SoftthanksScreen');
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
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Stack(
                        children: [
                          // Soft Thanks text
                          Positioned(
                            top: 0.h,
                            left: 21.h,
                            child: Text(
                              'Soft Thanks',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 33,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // Soft Thanks box
                          Positioned(
                            top: 47.h,
                            left: 19.h,
                            child: Stack(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/softthanks_box.svg',
                                  width: 380.h,
                                  height: 33.h,
                                  fit: BoxFit.contain,
                                ),
                                Positioned(
                                  top: 4.h,
                                  left: 19.h,
                                  child: Text(
                                    'Whispers of appreciation — gentle and honest.',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Moment box
                          Positioned(
                            top: 90.h,
                            left: 0,
                            right: 0,
                            child: Stack(
                              children: [
                                Center(
                                  child: SvgPicture.asset(
                                    'assets/images/moment_box.svg',
                                    width: 346.h,
                                    height: 125.h,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned(
                                  top: 15.h,
                                  left: 0,
                                  right: 0,
                                  child: Column(
                                    children: [
                                      Text(
                                        '💡What made you pause today? What felt light,\nwarm, or worth remembering?',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      Stack(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/keep_this_moment.svg',
                                            fit: BoxFit.contain,
                                          ),
                                          Positioned(
                                            left: 12.h,
                                            top: 0,
                                            bottom: 0,
                                            child: Row(
                                              children: [
                                                Center(
                                                  child: GestureDetector(
                                                    onTap: _showMomentWriter,
                                                    child: SvgPicture.asset(
                                                      'assets/images/plus_ktm.svg',
                                                      width: 16.h,
                                                      height: 16.h,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 4.h),
                                                Center(
                                                  child: GestureDetector(
                                                    onTap: _showMomentWriter,
                                                    child: Text(
                                                      'Keep This Moment',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
                          ),
                          // Moments list
                          Positioned(
                            top: 231.h,
                            left: 0,
                            right: 0,
                            child: !_isInitialized
                                ? SizedBox.shrink()
                                : StreamBuilder<QuerySnapshot>(
                                    stream: userEmail != null
                                        ? FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(userEmail)
                                            .collection('softthanks')
                                            .orderBy(FieldPath.documentId)
                                            .snapshots()
                                        : null,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        print('Error loading softthanks: ${snapshot.error}');
                                        return SizedBox.shrink();
                                      }

                                      if (!snapshot.hasData) {
                                        return SizedBox.shrink();
                                      }
                                      
                                      final moments = snapshot.data!.docs
                                          .map((doc) => doc['text'] as String)
                                          .toList();
                                      
                                      return Column(
                                        children: List.generate(moments.length, (index) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              top: index == 0 ? 0 : 16.h,
                                              left: 16.h,
                                              right: 16.h,
                                            ),
                                            child: GestureDetector(
                                              onTap: () => _showMomentViewer(moments[index]),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/images/st_text.svg',
                                                    fit: BoxFit.contain,
                                                  ),
                                                  Positioned.fill(
                                                    child: Center(
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 16.h),
                                                        child: Text(
                                                          moments[index],
                                                          style: TextStyle(
                                                            fontFamily: 'Roboto',
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                      );
                                    },
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

  void _showMomentWriter() {
    final TextEditingController textController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Color(0xFFBCBCBC).withOpacity(0.04),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFBCBCBC).withOpacity(0.04),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
              ),
              child: Column(
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
                    "Capture This Moment",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16.h),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.h,
                          ),
                        ),
                        child: TextField(
                          controller: textController,
                          maxLines: null,
                          expands: true,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.5,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Write what made this moment special...',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16.h),
                          ),
                          onSubmitted: (_) => FocusScope.of(context).unfocus(),
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.h, right: 16.h, bottom: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (textController.text.isNotEmpty && userEmail != null) {
                              print('Adding moment: ${textController.text}');
                              // Get the next softthanks number
                              final softthanksCollection = FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userEmail)
                                  .collection('softthanks');
                              final snapshot = await softthanksCollection.get();
                              final nextNumber = snapshot.docs.length + 1;
                              final docName = 'softthanks${nextNumber}';
                              await softthanksCollection.doc(docName).set({
                                'text': textController.text,
                              });
                              // Scroll to bottom if there are more than 6 moments
                              if (snapshot.docs.length + 1 > 6) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                  );
                                });
                              }
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
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
    );
  }

  void _showMomentViewer(String momentText) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Color(0xFFBCBCBC).withOpacity(0.04),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFBCBCBC).withOpacity(0.04),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
              ),
              child: Column(
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
                    "Your Moment",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16.h),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.h,
                          ),
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(16.h),
                          child: Text(
                            momentText,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.h),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Close',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
