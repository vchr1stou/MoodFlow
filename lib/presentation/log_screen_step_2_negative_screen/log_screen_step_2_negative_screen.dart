import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moodflow/presentation/log_screen/log_screen.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/size_utils.dart' as size_utils;
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
    _loadSavedData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: _buildAppbar(context),
      body: Stack(
        children: [
          // Your existing body content here
          
          // Next button
          Positioned(
            right: size_utils.ResponsiveExtension(12).h,
            bottom: size_utils.ResponsiveExtension(50).h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Save current state before navigating
                    StorageService.saveNegativeFeelings(selectedFeelings);
                    StorageService.saveNegativeIntensities(intensities);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LogScreenStep3PositiveScreen(
                          selectedFeelings: [],
                        ),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/images/next_log.svg',
                    width: size_utils.ResponsiveExtension(142).h,
                    height: size_utils.ResponsiveExtension(42).h,
                  ),
                ),
                Positioned(
                  top: size_utils.ResponsiveExtension(8).h,
                  child: GestureDetector(
                    onTap: () {
                      // Save current state before navigating
                      StorageService.saveNegativeFeelings(selectedFeelings);
                      StorageService.saveNegativeIntensities(intensities);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LogScreenStep3PositiveScreen(
                            selectedFeelings: [],
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
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: size_utils.ResponsiveExtension(200).h,
      leading: Row(
        children: [
          GestureDetector(
            onTap: () {
              final savedMood = StorageService.getCurrentMood();
              final savedMoodSource = StorageService.getMoodSource();
              print('Step 2 Negative - Going back with mood: $savedMood from source: $savedMoodSource');
              
              if (savedMood != null && savedMoodSource != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LogScreen(
                      source: 'log_screen',
                      emojiSource: savedMoodSource,
                      feeling: savedMood,
                    ),
                  ),
                );
              }
            },
            child: Padding(
              padding: EdgeInsets.only(
                left: size_utils.ResponsiveExtension(16).h,
                top: size_utils.ResponsiveExtension(10).h,
              ),
              child: SvgPicture.asset(
                'assets/images/back_log.svg',
                width: size_utils.ResponsiveExtension(27).h,
                height: size_utils.ResponsiveExtension(27).h,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 