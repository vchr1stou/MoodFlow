import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import '../../core/services/storage_service.dart';
import '../../core/utils/size_utils.dart';
import 'log_screen/log_screen.dart';
import 'log_screen_step_3_negative_screen/log_screen_step_3_negative_screen.dart';
import 'log_screen_step_3_positive_screen/log_screen_step_3_positive_screen.dart';
import 'log_screen_step_2_positive_screen/log_screen_step_2_positive_screen.dart';

class LogScreenStep2NegativeScreen extends StatefulWidget {
  const LogScreenStep2NegativeScreen({Key? key}) : super(key: key);

  @override
  State<LogScreenStep2NegativeScreen> createState() => _LogScreenStep2NegativeScreenState();

  // Add static method to clear all static data
  static void clearAllData() {
    debugPrint('[NEGATIVE] clearAllData called');
    // Save current mood data
    final savedMood = StorageService.getCurrentMood();
    final savedMoodSource = StorageService.getMoodSource();
    
    // Clear static variables
    selectedNegativeFeelings = [];
    storedSelectedButtons = {};
    // Clear stored slider values from step 3
    LogScreenStep3NegativeScreenState.storedSliderValues.clear();
    debugPrint('[NEGATIVE] Static variables and storedSliderValues cleared');
    
    // Clear all storage data
    StorageService.clearAll();
    debugPrint('[NEGATIVE] All storage data cleared');
    
    // Force clear negative feelings and intensities specifically
    StorageService.saveNegativeFeelings([]);
    StorageService.saveNegativeIntensities({});
    debugPrint('[NEGATIVE] Negative feelings and intensities explicitly cleared');
    
    // Restore mood data
    if (savedMood != null && savedMoodSource != null) {
      StorageService.saveCurrentMood(savedMood, savedMoodSource);
      debugPrint('[NEGATIVE] Restored mood data: $savedMood from $savedMoodSource');
    }
  }

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
    debugPrint('[NEGATIVE] All data cleared in resetSvgTypes');
  }
}

class _LogScreenStep2NegativeScreenState extends State<LogScreenStep2NegativeScreen> {
  List<String> selectedFeelings = [];
  Map<String, double> intensities = {};
  String? _currentMood;
  String? _moodSource;

  @override
  void initState() {
    super.initState();
    debugPrint('[NEGATIVE] initState called');
    
    // Load saved mood first before clearing other data
    final savedMood = StorageService.getCurrentMood();
    final savedMoodSource = StorageService.getMoodSource();
    
    // Clear all data except mood
    LogScreenStep2NegativeScreen.clearAllData();
    
    // Restore mood data
    if (savedMood != null && savedMoodSource != null) {
      StorageService.saveCurrentMood(savedMood, savedMoodSource);
    }
    
    // Reset local state
    setState(() {
      selectedFeelings = [];
      intensities = {};
      _currentMood = savedMood;
      _moodSource = savedMoodSource;
    });
    
    debugPrint('[NEGATIVE] Local state reset - selectedFeelings: $selectedFeelings, intensities: $intensities');
    
    // Force a rebuild
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  void _resetSelectedFeelings() {
    debugPrint('[NEGATIVE] _resetSelectedFeelings called');
    setState(() {
      selectedFeelings = [];
      intensities = {};
    });
    StorageService.saveNegativeFeelings([]);
    StorageService.saveNegativeIntensities({});
    // Also clear static variables
    LogScreenStep2NegativeScreen.clearAllData();
    debugPrint('[NEGATIVE] Local state, static variables, and storage cleared');
  }

  Future<void> _loadSavedData() async {
    debugPrint('[NEGATIVE] _loadSavedData called');
    // Load saved mood
    final savedMood = StorageService.getCurrentMood();
    final savedMoodSource = StorageService.getMoodSource();
    debugPrint('[NEGATIVE] Loaded saved mood: $savedMood from source: $savedMoodSource');
    
    if (savedMood != null && savedMoodSource != null) {
      setState(() {
        _currentMood = savedMood;
        _moodSource = savedMoodSource;
      });
    }

    // Only load saved feelings if we're not in a reset state
    if (LogScreenStep2NegativeScreen.selectedNegativeFeelings.isEmpty) {
      // Load saved feelings and intensities
      final savedFeelings = StorageService.getNegativeFeelings();
      final savedIntensities = StorageService.getNegativeIntensities();
      debugPrint('[NEGATIVE] Loaded from storage: feelings=$savedFeelings, intensities=$savedIntensities');
      
      setState(() {
        selectedFeelings = savedFeelings;
        intensities = savedIntensities;
      });

      // Update static variables
      LogScreenStep2NegativeScreen.selectedNegativeFeelings = List.from(savedFeelings);
      debugPrint('[NEGATIVE] Static selectedNegativeFeelings: ${LogScreenStep2NegativeScreen.selectedNegativeFeelings}');
    } else {
      debugPrint('[NEGATIVE] Skipping load of saved feelings as we are in reset state');
    }
  }

  void _onFeelingSelected(String feeling) {
    debugPrint('[NEGATIVE] _onFeelingSelected: $feeling');
    debugPrint('[NEGATIVE] Current state before change - selectedFeelings: $selectedFeelings, intensities: $intensities');
    
    // Save current mood data
    final savedMood = StorageService.getCurrentMood();
    final savedMoodSource = StorageService.getMoodSource();
    
    // Clear only feelings data
    setState(() {
      if (selectedFeelings.contains(feeling)) {
        selectedFeelings.remove(feeling);
        intensities.remove(feeling);
      } else {
        // Clear any previous data for this feeling
        if (intensities.containsKey(feeling)) {
          intensities.remove(feeling);
        }
        selectedFeelings.add(feeling);
        intensities[feeling] = 0.5; // Default intensity
      }
    });

    // Save new data
    StorageService.saveNegativeFeelings(selectedFeelings);
    StorageService.saveNegativeIntensities(intensities);
    
    // Restore mood data
    if (savedMood != null && savedMoodSource != null) {
      StorageService.saveCurrentMood(savedMood, savedMoodSource);
    }
    
    debugPrint('[NEGATIVE] After select - selectedFeelings: $selectedFeelings, intensities: $intensities');
    
    // Force a rebuild of the widget
    setState(() {});
  }

  void _onIntensityChanged(String feeling, double value) {
    debugPrint('[NEGATIVE] _onIntensityChanged: $feeling -> $value');
    setState(() {
      intensities[feeling] = value;
    });
    StorageService.saveNegativeIntensities(intensities);
    debugPrint('[NEGATIVE] Intensities after change: $intensities');
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
                                      debugPrint('[NEGATIVE] Next tapped. Saving and navigating.');
                                      // Save current mood data
                                      final savedMood = StorageService.getCurrentMood();
                                      final savedMoodSource = StorageService.getMoodSource();
                                      
                                      // Save feelings to storage before navigating
                                      StorageService.saveNegativeFeelings(selectedFeelings);
                                      StorageService.saveNegativeIntensities(intensities);
                                      
                                      // Restore mood data
                                      if (savedMood != null && savedMoodSource != null) {
                                        StorageService.saveCurrentMood(savedMood, savedMoodSource);
                                      }
                                      
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
                                        debugPrint('[NEGATIVE] Next (text) tapped. Saving and navigating.');
                                        // Save current mood data
                                        final savedMood = StorageService.getCurrentMood();
                                        final savedMoodSource = StorageService.getMoodSource();
                                        
                                        // Save feelings to storage before navigating
                                        StorageService.saveNegativeFeelings(selectedFeelings);
                                        StorageService.saveNegativeIntensities(intensities);
                                        
                                        // Restore mood data
                                        if (savedMood != null && savedMoodSource != null) {
                                          StorageService.saveCurrentMood(savedMood, savedMoodSource);
                                        }
                                        
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
    // Only check local state for selection
    final isSelected = selectedFeelings.contains(feeling);
    debugPrint('[NEGATIVE] Building button for $feeling, isSelected: $isSelected, selectedFeelings: $selectedFeelings');
    
    return GestureDetector(
      onTap: () {
        debugPrint('[NEGATIVE] Button tapped: $feeling');
        _onFeelingSelected(feeling);
      },
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