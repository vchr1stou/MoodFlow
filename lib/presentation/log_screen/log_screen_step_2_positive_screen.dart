import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/size_utils.dart';
import '../log_screen/log_screen.dart';

class LogScreenStep2PositiveScreen extends StatefulWidget {
  const LogScreenStep2PositiveScreen({Key? key}) : super(key: key);

  @override
  State<LogScreenStep2PositiveScreen> createState() => _LogScreenStep2PositiveScreenState();
}

class _LogScreenStep2PositiveScreenState extends State<LogScreenStep2PositiveScreen> {
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
    StorageService.savePositiveFeelings([]);
    StorageService.savePositiveIntensities({});
  }

  Future<void> _loadSavedData() async {
    // Load saved mood
    final savedMood = StorageService.getCurrentMood();
    final savedMoodSource = StorageService.getMoodSource();
    print('Step 2 Positive - Loaded saved mood: $savedMood from source: $savedMoodSource');
    
    if (savedMood != null && savedMoodSource != null) {
      setState(() {
        _currentMood = savedMood;
        _moodSource = savedMoodSource;
      });
    }

    // Load saved feelings and intensities
    final savedFeelings = StorageService.getPositiveFeelings();
    final savedIntensities = StorageService.getPositiveIntensities();
    
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
    StorageService.savePositiveFeelings(selectedFeelings);
    StorageService.savePositiveIntensities(intensities);
  }

  void _onIntensityChanged(String feeling, double value) {
    setState(() {
      intensities[feeling] = value;
    });
    StorageService.savePositiveIntensities(intensities);
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 200.h,
      leading: Row(
        children: [
          GestureDetector(
            onTap: () async {
              // Clear all saved data before navigating
              await StorageService.clearAll();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LogScreen.builder(
                    context,
                    feeling: "Bright 😊",
                  ),
                ),
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

  @override
  Widget build(BuildContext context) {
    return Container(); // Replace with your existing build implementation
  }
} 