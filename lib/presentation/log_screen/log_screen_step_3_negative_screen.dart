import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/size_utils.dart';
import '../log_screen/log_screen.dart';
import '../log_screen_step_four_screen/log_screen_step_four_screen.dart';

class LogScreenStep3NegativeScreen extends StatefulWidget {
  const LogScreenStep3NegativeScreen({Key? key}) : super(key: key);

  // Static method to clear all data
  static void clearAllData() {
    StorageService.saveNegativeFeelings([]);
    StorageService.saveNegativeIntensities({});
    _LogScreenStep3NegativeScreenState.storedSliderValues.clear();
  }

  @override
  State<LogScreenStep3NegativeScreen> createState() => _LogScreenStep3NegativeScreenState();
}

class _LogScreenStep3NegativeScreenState extends State<LogScreenStep3NegativeScreen> {
  List<String> selectedFeelings = [];
  Map<String, double> intensities = {};
  
  // Static map to store slider values
  static Map<String, double> storedSliderValues = {};

  @override
  void initState() {
    super.initState();
    _loadSavedFeelings();
  }

  Future<void> _loadSavedFeelings() async {
    final savedFeelings = StorageService.getNegativeFeelings();
    final savedIntensities = StorageService.getNegativeIntensities();
    
    setState(() {
      selectedFeelings = savedFeelings;
      intensities = savedIntensities;
      // Update static map with saved intensities
      storedSliderValues = Map.from(savedIntensities);
    });
    print('Loaded saved feelings: $savedFeelings');
    print('Loaded saved intensities: $savedIntensities');
  }

  void _onIntensityChanged(String feeling, double value) {
    setState(() {
      intensities[feeling] = value;
      // Update static map
      storedSliderValues[feeling] = value;
      
      // Ensure the feeling is in selectedFeelings
      if (!selectedFeelings.contains(feeling)) {
        selectedFeelings.add(feeling);
        StorageService.saveNegativeFeelings(selectedFeelings);
      }
    });
    StorageService.saveNegativeIntensities(intensities);
    print('Updated intensity for $feeling: $value');
    print('Current storedSliderValues: $storedSliderValues');
  }

  Future<void> _saveNegativeFeelings(String subcollectionName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      print('No user found, cannot save negative feelings');
      return;
    }

    print('Starting to save negative feelings...');
    print('Current storedSliderValues: $storedSliderValues');
    
    // Use storedSliderValues directly to save feelings
    if (storedSliderValues.isEmpty) {
      print('No negative feelings to save');
      return;
    }
    
    // Save each negative feeling as a separate document
    for (var entry in storedSliderValues.entries) {
      final feeling = entry.key;
      final intensity = entry.value.round();
      
      print('Processing feeling: $feeling with intensity: $intensity');
      
      try {
        // Create a document with the feeling name as the ID
        final docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('logs')
            .doc(subcollectionName)
            .collection('negative_feelings')
            .doc(feeling);  // Use feeling name as document ID

        // Set the document data with the rounded intensity
        await docRef.set({
          'intensity': intensity,  // Save the rounded intensity value
          'timestamp': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        print('Successfully saved negative feeling document: $feeling with intensity: $intensity');
      } catch (e) {
        print('Error saving negative feeling $feeling: $e');
      }
    }
    
    print('Finished saving negative feelings');
  }

  Future<void> _handleNext() async {
    print('Handling next button press...');
    
    // Get the current timestamp for the subcollection name
    final now = DateTime.now();
    final subcollectionName = '${now.day.toString().padLeft(2, '0')}_${now.month.toString().padLeft(2, '0')}_${now.year}_${now.hour.toString().padLeft(2, '0')}_${now.minute.toString().padLeft(2, '0')}_${now.second.toString().padLeft(2, '0')}';
    
    print('Generated subcollection name: $subcollectionName');
    print('Current storedSliderValues before save: $storedSliderValues');
    
    // Save negative feelings to Firestore
    await _saveNegativeFeelings(subcollectionName);
    
    print('Navigation to next screen...');
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LogScreenStepFourScreen.builder(context),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          );
          var scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          );
          return FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 400),
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
            // Your existing content here
            
            // Next button with absolute positioning
            Positioned(
              right: 12.h,
              bottom: 50.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: _handleNext,
                    child: SvgPicture.asset(
                      'assets/images/next_log.svg',
                      width: 142.h,
                      height: 42.h,
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    child: GestureDetector(
                      onTap: _handleNext,
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
            onTap: () async {
              // Clear all saved data before navigating
              await StorageService.clearAll();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LogScreen.builder(
                    context,
                    feeling: "Heavy 😔",
                    source: 'history',
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
} 