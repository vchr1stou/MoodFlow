import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import '../../core/services/storage_service.dart';
import '../../core/utils/size_utils.dart';
import '../log_screen/log_screen.dart';
import '../log_screen_step_3_negative_screen/log_screen_step_3_negative_screen.dart';

class LogScreenStep2NegativeScreen extends StatefulWidget {
  const LogScreenStep2NegativeScreen({Key? key}) : super(key: key);

  // Static variables
  static List<String> selectedNegativeFeelings = [];
  static Set<int> storedSelectedButtons = {};

  static void resetSvgTypes() {
    // Reset all SVG types to their default state
    StorageService.saveNegativeFeelings([]);
    StorageService.saveNegativeIntensities({});
    // Clear stored slider values from step 3
    LogScreenStep3NegativeScreenState.storedSliderValues.clear();
    // Clear static variables
    selectedNegativeFeelings.clear();
    storedSelectedButtons.clear();
  }

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

  @override
  void dispose() {
    // Save state when the screen is disposed
    LogScreenStep2NegativeScreen.selectedNegativeFeelings = List.from(selectedFeelings);
    LogScreenStep2NegativeScreen.storedSelectedButtons = Set.from(selectedFeelings.map((feeling) => _getFeelingIndex(feeling)));
    super.dispose();
  }

  int _getFeelingIndex(String feeling) {
    final feelings = ['Sad', 'Angry', 'Anxious', 'Stressed', 'Tired', 'Bored', 'Lonely', 'Frustrated', 'Ashamed', 'Exhausted'];
    return feelings.indexOf(feeling);
  }

  void _resetSelectedFeelings() {
    setState(() {
      selectedFeelings = [];
      intensities = {};
    });
    StorageService.saveNegativeFeelings([]);
    StorageService.saveNegativeIntensities({});
    // Clear stored slider values
    LogScreenStep3NegativeScreenState.storedSliderValues.clear();
    // Clear static variables
    LogScreenStep2NegativeScreen.selectedNegativeFeelings.clear();
    LogScreenStep2NegativeScreen.storedSelectedButtons.clear();
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
      // Update static variables
      LogScreenStep2NegativeScreen.selectedNegativeFeelings = List.from(savedFeelings);
      LogScreenStep2NegativeScreen.storedSelectedButtons = Set.from(savedFeelings.map((feeling) => _getFeelingIndex(feeling)));
    });
    print('Loaded negative feelings: ${LogScreenStep2NegativeScreen.selectedNegativeFeelings}');
  }

  void _onFeelingSelected(String feeling) {
    setState(() {
      if (selectedFeelings.contains(feeling)) {
        selectedFeelings.remove(feeling);
        intensities.remove(feeling);
        // Also remove from static list
        LogScreenStep2NegativeScreen.selectedNegativeFeelings.remove(feeling);
        LogScreenStep2NegativeScreen.storedSelectedButtons.remove(_getFeelingIndex(feeling));
      } else {
        selectedFeelings.add(feeling);
        intensities[feeling] = 0.5; // Default intensity
        // Also add to static list
        LogScreenStep2NegativeScreen.selectedNegativeFeelings.add(feeling);
        LogScreenStep2NegativeScreen.storedSelectedButtons.add(_getFeelingIndex(feeling));
      }
    });
    StorageService.saveNegativeFeelings(selectedFeelings);
    StorageService.saveNegativeIntensities(intensities);
    print('Selected negative feelings updated: ${LogScreenStep2NegativeScreen.selectedNegativeFeelings}');
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
                            // Feelings grid
                            Wrap(
                              spacing: 10.h,
                              runSpacing: 10.h,
                              alignment: WrapAlignment.center,
                              children: [
                                _buildFeelingButton('Sad', 0),
                                _buildFeelingButton('Angry', 1),
                                _buildFeelingButton('Anxious', 2),
                                _buildFeelingButton('Stressed', 3),
                                _buildFeelingButton('Tired', 4),
                                _buildFeelingButton('Bored', 5),
                                _buildFeelingButton('Lonely', 6),
                                _buildFeelingButton('Frustrated', 7),
                                _buildFeelingButton('Ashamed', 8),
                                _buildFeelingButton('Exhausted', 9),
                              ],
                            ),
                            SizedBox(height: 50.h),
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

  Widget _buildFeelingButton(String feeling, int index) {
    final isSelected = selectedFeelings.contains(feeling);
    return GestureDetector(
      onTap: () => _onFeelingSelected(feeling),
      child: Container(
        width: 100.h,
        height: 100.h,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20.h),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
            width: 2.h,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/negative_$index.svg',
              width: 40.h,
              height: 40.h,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
            ),
            SizedBox(height: 8.h),
            Text(
              feeling,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 