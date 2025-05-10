import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import '../../core/services/storage_service.dart';
import '../../core/utils/size_utils.dart';
import 'log_screen/log_screen.dart';
import 'log_screen_step_3_negative_screen/log_screen_step_3_negative_screen.dart';
import 'log_screen_step_3_positive_screen/log_screen_step_3_positive_screen.dart';

class LogScreenStep2NegativeScreen extends StatefulWidget {
  const LogScreenStep2NegativeScreen({Key? key}) : super(key: key);

  @override
  State<LogScreenStep2NegativeScreen> createState() => _LogScreenStep2NegativeScreenState();

  // Add static method to clear all static data
  static void clearAllData() {
    selectedNegativeFeelings = [];
    storedSelectedButtons = {};
  }

  // Static variables
  static List<String> selectedNegativeFeelings = [];
  static Set<int> storedSelectedButtons = {};
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
    // Also clear static variables
    LogScreenStep2NegativeScreen.clearAllData();
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
      LogScreenStep2NegativeScreen.selectedNegativeFeelings = savedFeelings;
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
    // Update static variable
    LogScreenStep2NegativeScreen.selectedNegativeFeelings = selectedFeelings;
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
      body: SafeArea(
        child: Column(
          children: [
            // Your existing UI widgets here
            Text('Negative Feelings Screen'),
            // Add your feelings selection UI here
          ],
        ),
      ),
    );
  }
} 