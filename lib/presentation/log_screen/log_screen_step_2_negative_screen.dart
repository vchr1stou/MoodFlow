import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import '../../core/services/storage_service.dart';
import '../../core/utils/size_utils.dart';
import '../log_screen/log_screen.dart';
import '../log_screen_step_3_negative_screen/log_screen_step_3_negative_screen.dart';
import '../log_screen_step_3_positive_screen/log_screen_step_3_positive_screen.dart';

class LogScreenStep2NegativeScreen extends StatefulWidget {
  const LogScreenStep2NegativeScreen({Key? key}) : super(key: key);

  @override
  State<LogScreenStep2NegativeScreen> createState() => _LogScreenStep2NegativeScreenState();
}

class _LogScreenStep2NegativeScreenState extends State<LogScreenStep2NegativeScreen> {
  List<String> selectedFeelings = [];
  Map<String, double> intensities = {};
  String? _currentMood;
  String? _moodSource;

  @override
  void initState() {
    super.initState();
    _resetSelectedFeelings();
    _loadSavedData();
  }

  void _resetSelectedFeelings() {
    setState(() {
      selectedFeelings = [];
      intensities = {};
    });
    StorageService.saveNegativeFeelings([]);
    StorageService.saveNegativeIntensities({});
  }

  Future<void> _loadSavedData() async {
    // Load saved mood
    final savedMood = StorageService.getCurrentMood();
    final savedMoodSource = StorageService.getMoodSource();
    print('Step 2 Negative - Loaded saved mood: $savedMood from source: $savedMoodSource');
    
    if (savedMood != null && savedMoodSource != null) {
      setState(() {
        _currentMood = savedMood;
        _moodSource = savedMoodSource;
      });
    }

    // Load saved feelings and intensities
    final savedFeelings = StorageService.getNegativeFeelings();
    final savedIntensities = StorageService.getNegativeIntensities();
    
    setState(() {
      selectedFeelings = savedFeelings;
      intensities = savedIntensities;
    });
  }

  void _onFeelingSelected(String feeling) {
    setState(() {
      if (selectedFeelings.contains(feeling)) {
        selectedFeelings.remove(feeling);
        intensities.remove(feeling);
      } else {
        selectedFeelings.add(feeling);
        intensities[feeling] = 0.5; // Default intensity
      }
    });
    StorageService.saveNegativeFeelings(selectedFeelings);
    StorageService.saveNegativeIntensities(intensities);
  }

  void _onIntensityChanged(String feeling, double value) {
    setState(() {
      intensities[feeling] = value;
    });
    StorageService.saveNegativeIntensities(intensities);
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
              // Simply pop back to the previous screen
              Navigator.pop(context);
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
                  color: Color(0xFF808080).withOpacity(0.2),
                ),
              ),
            ),
            // Content
            SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 87.h),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              "Select Feelings",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                height: 30/36,
                                letterSpacing: -2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 23.h),
                            // Your feelings selection UI here
                            // ... existing code ...
                            
                            // Next button
                            Positioned(
                              right: 12.h,
                              bottom: 50.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Save feelings to storage before navigating
                                      StorageService.saveNegativeFeelings(selectedFeelings);
                                      StorageService.saveNegativeIntensities(intensities);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LogScreenStep3NegativeScreen(
                                            selectedFeelings: selectedFeelings,
                                          ),
                                        ),
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      'assets/images/next_log.svg',
                                      width: 142.h,
                                      height: 42.h,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8.h,
                                    child: GestureDetector(
                                      onTap: () {
                                        // Save feelings to storage before navigating
                                        StorageService.saveNegativeFeelings(selectedFeelings);
                                        StorageService.saveNegativeIntensities(intensities);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LogScreenStep3NegativeScreen(
                                              selectedFeelings: selectedFeelings,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Next",
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 15,
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 