import 'dart:math';
import 'dart:ui';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../core/app_export.dart';
import '../log_screen_step_four_screen/log_screen_step_four_screen.dart';
import '../homescreen_screen/homescreen_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'provider/log_screen_step_five_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../core/services/storage_service.dart';
import '../../services/log_service.dart';
import '../log_screen_step_2_positive_screen/log_screen_step_2_positive_screen.dart';
import '../log_screen_step_2_negative_screen/log_screen_step_2_negative_screen.dart';
import '../log_screen_step_3_negative_screen/log_screen_step_3_negative_screen.dart';
import '../log_screen_step_3_positive_screen/log_screen_step_3_positive_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class Particle {
  Offset position;
  Color color;
  double size;
  double velocityY;
  double rotation;
  int shape; // 0: rectangle, 1: diamond

  Particle({
    required this.position,
    required this.color,
    required this.size,
    required this.shape,
    this.velocityY = 2.0,
    required this.rotation,
  });
}

class LogScreenStepFiveScreen extends StatefulWidget {
  const LogScreenStepFiveScreen({Key? key}) : super(key: key);

  @override
  LogScreenStepFiveScreenState createState() => LogScreenStepFiveScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogScreenStepFiveProvider(),
      child: LogScreenStepFiveScreen(),
    );
  }
}

class LogScreenStepFiveScreenState extends State<LogScreenStepFiveScreen> with TickerProviderStateMixin {
  double _alignX = 0.0;
  double _smoothX = 0.0;
  static const double _sensitivity = 0.8;
  static const double _smoothingFactor = 0.7;
  bool _isInitialized = false;

  final List<Particle> _particles = [];
  late AnimationController _animationController;
  final Random _random = Random();

  static const List<Color> _colors = [
    Color(0xFFFF1D44), // Red
    Color(0xFFFFD100), // Gold
    Color(0xFF00E0FF), // Blue
    Color(0xFFFF8D00), // Orange
    Color(0xFFFFFFFF), // White
    Color(0xFF00FF94), // Green
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _animationController.addListener(_updateParticles);

    accelerometerEvents.listen((AccelerometerEvent event) {
      if (mounted) {
        setState(() {
          final targetX = (-event.x * _sensitivity).clamp(-1.0, 1.0);
          _smoothX = _smoothX * _smoothingFactor + targetX * (1 - _smoothingFactor);
          _alignX = _smoothX;
        });
      }
    });
  }

  void _generateParticles(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _particles.clear();

    for (int i = 0; i < 100; i++) {
      _particles.add(
        Particle(
          position: Offset(
            _random.nextDouble() * size.width,
            -size.height + (_random.nextDouble() * size.height * 2),
          ),
          color: _colors[_random.nextInt(_colors.length)],
          size: 2 + _random.nextDouble() * 3,
          shape: _random.nextInt(2),
          rotation: _random.nextDouble() * pi * 2,
        ),
      );
    }
  }

  void _updateParticles() {
    if (!mounted || !_isInitialized) return;

    final size = MediaQuery.of(context).size;
    for (var particle in _particles) {
      final swayAmount = sin(_animationController.value * pi * 2) * 0.5;

      particle.position = Offset(
        particle.position.dx + _alignX * 6 + swayAmount,
        particle.position.dy + particle.velocityY,
      );

      particle.rotation += 0.05 + (swayAmount.abs() * 0.05);

      if (particle.position.dy > size.height) {
        particle.position = Offset(
          _random.nextDouble() * size.width,
          -particle.size * 2,
        );
        particle.rotation = _random.nextDouble() * pi * 2;
      }

      if (particle.position.dx < -particle.size * 3) {
        particle.position = Offset(size.width + particle.size * 3, particle.position.dy);
      } else if (particle.position.dx > size.width + particle.size * 3) {
        particle.position = Offset(-particle.size * 3, particle.position.dy);
      }
    }
    setState(() {});
  }

  Future<void> _saveLogToFirestore() async {
    try {
      final auth = FirebaseAuth.instance;
      final user = auth.currentUser;
      
      print('Checking authentication state...');
      if (user == null) {
        throw Exception('User is not authenticated');
      }
      
      print('User is authenticated. Email: ${user.email}');
      if (user.email == null) {
        throw Exception('User email is null');
      }

      final logService = LogService();
      
      // Get only the required data
      final mood = StorageService.getCurrentMood();
      final timestamp = await StorageService.getSelectedDateTime();
      final toggledIcons = StorageService.getToggledIcons();
      final contacts = await StorageService.getSelectedContacts();
      final locationName = await StorageService.getSelectedLocation();
      final locationCoords = await StorageService.getLocationCoordinates();

      print('Retrieved data - Mood: $mood, Timestamp: $timestamp, Toggled Icons: $toggledIcons, Contacts: ${contacts.length}, Location: $locationName');

      // Check each required field and create a list of missing fields
      List<String> missingFields = [];
      if (mood == null) missingFields.add('mood');
      if (timestamp == null) missingFields.add('timestamp');

      // If any fields are missing, throw an exception with details
      if (missingFields.isNotEmpty) {
        throw Exception('Missing required fields: ${missingFields.join(", ")}');
      }

      // Format the date and time for the subcollection name
      final day = timestamp!.day.toString().padLeft(2, '0');
      final month = timestamp.month.toString().padLeft(2, '0');
      final year = timestamp.year.toString();
      final hour = timestamp.hour.toString().padLeft(2, '0');
      final minute = timestamp.minute.toString().padLeft(2, '0');
      final second = timestamp.second.toString().padLeft(2, '0');
      final subcollectionName = '${day}_${month}_${year}_${hour}_${minute}_${second}';

      print('Attempting to save log with subcollection name: $subcollectionName');

      // Save to Firestore with the formatted subcollection name and toggled icons
      await logService.saveLog(
        mood: mood!,
        timestamp: timestamp,
        subcollectionName: subcollectionName,
        toggledIcons: toggledIcons,
        contacts: contacts,
      );

      // Save location data in map subcollection if available
      if (locationName != null && locationCoords != null) {
        print('Saving location data to map subcollection');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('logs')
            .doc(subcollectionName)
            .collection('map')
            .doc('location')
            .set({
          'name': locationName,
          'latitude': locationCoords['lat'],
          'longitude': locationCoords['lng'],
          'timestamp': timestamp,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Save positive feelings and their intensities
      final selectedPositiveFeelings = LogScreenStep2PositiveScreen.selectedPositiveFeelings;
      final positiveFeelingIntensities = LogScreenStep3PositiveScreenState.storedSliderValues;

      if (selectedPositiveFeelings.isNotEmpty) {
        print('Saving positive feelings and intensities');
        final positiveFeelingsData = selectedPositiveFeelings.map((feeling) {
          return {
            'name': feeling,
            'intensity': positiveFeelingIntensities[feeling]?.round() ?? 0,
            'timestamp': timestamp,
            'createdAt': FieldValue.serverTimestamp(),
          };
        }).toList();

        // Save each positive feeling as a separate document
        for (var feelingData in positiveFeelingsData) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.email)
              .collection('logs')
              .doc(subcollectionName)
              .collection('positive_feelings')
              .doc(feelingData['name'] as String)
              .set(feelingData);
        }
      }

      // Save negative feelings and their intensities
      final negativeFeelingIntensities = LogScreenStep3NegativeScreenState.storedSliderValues;

      print('Negative feeling intensities: $negativeFeelingIntensities');

      if (negativeFeelingIntensities.isNotEmpty) {
        print('Saving negative feelings and intensities');
        
        // Save each negative feeling as a separate document in the negative_feelings subcollection
        for (var entry in negativeFeelingIntensities.entries) {
          final feeling = entry.key;
          final intensity = entry.value.round();
          
          print('Saving negative feeling: $feeling with intensity: $intensity');
          
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.email)
              .collection('logs')
              .doc(subcollectionName)
              .collection('negative_feelings')
              .doc(feeling)  // Use feeling name as document ID
              .set({
            'intensity': intensity,
            'timestamp': timestamp,
            'createdAt': FieldValue.serverTimestamp(),
          });
          
          print('Successfully saved negative feeling document: $feeling');
        }
        print('Successfully saved all negative feelings data');
      } else {
        print('No negative feelings to save');
      }

      // Save journal text and Spotify track
      final journalText = await StorageService.getJournalText();
      final selectedTrack = await StorageService.getSelectedTrack();
      final selectedPhotos = await StorageService.getSelectedPhotos();
      
      print('Selected track data: $selectedTrack'); // Debug log
      
      if (journalText != null && journalText.isNotEmpty) {
        print('Saving journal text');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('logs')
            .doc(subcollectionName)
            .collection('Journal')
            .doc('text')
            .set({
          'text': journalText,
          'timestamp': timestamp,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Save Spotify track in its own subcollection
      if (selectedTrack != null && selectedTrack.isNotEmpty && selectedTrack['id'] != null) {
        print('Saving Spotify track data');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('logs')
            .doc(subcollectionName)
            .collection('Spotify')
            .doc('track')
            .set({
          'id': selectedTrack['id'],
          'name': selectedTrack['name'] ?? '',
          'artist': selectedTrack['artist'] ?? '',
          'album': selectedTrack['album'] ?? '',
          'imageUrl': selectedTrack['imageUrl'] ?? '',
          'timestamp': timestamp,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Save photos in Photos subcollection
      if (selectedPhotos != null && selectedPhotos.isNotEmpty) {
        print('Saving photos to Firebase Storage');
        final storage = FirebaseStorage.instance;
        
        // Get the saved photo paths
        final photoPaths = await StorageService.getSelectedPhotoPaths();
        print('Retrieved photo paths: $photoPaths');
        
        // Create a document to store photo names
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('logs')
            .doc(subcollectionName)
            .collection('Photos')
            .doc('photo_names')
            .set({
          'names': photoPaths.map((path) => path.split('/').last).toList(),
          'timestamp': timestamp,
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        print('Successfully saved photo names to Firestore');
      }

      // Clear all local storage data
      await StorageService.clearAll();
      
      // Reset all static data first
      LogScreenStep2PositiveScreen.resetSvgTypes();
      LogScreenStep2NegativeScreen.resetSvgTypes();
      LogScreenStep3PositiveScreenState.storedSliderValues.clear();
      LogScreenStep3NegativeScreenState.storedSliderValues.clear();
      
      // Clear all data again to ensure nothing remains
      await StorageService.clearAll();
      
      // Initialize with empty data
      await StorageService.saveSelectedDateTime(DateTime.now());
      await StorageService.saveCurrentMood('', '');
      await StorageService.savePositiveFeelings([]);
      await StorageService.saveNegativeFeelings([]);
      await StorageService.savePositiveIntensities({});
      await StorageService.saveNegativeIntensities({});

      // Navigate to the home screen
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => HomescreenScreen.builder(context),
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
          (route) => false,
        );
      }
    } on FirebaseException catch (e) {
      print('Firebase error saving log: ${e.code} - ${e.message}');
      print('Error details: ${e.toString()}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Firebase error: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error saving log: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving log: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _generateParticles(context);
        _isInitialized = true;
      });
    }

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
            // Confetti particles
            CustomPaint(
              painter: ParticlePainter(particles: _particles),
              size: Size.infinite,
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
                            SizedBox(height: 300.h),
                            Text(
                              "All the Feels, Captured!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Another step in your story",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
            // Next button with absolute positioning
            Positioned(
              right: 0,
              left: 0,
              bottom: 60.h,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await _saveLogToFirestore();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/next_log.svg',
                            width: 142.h,
                            height: 42.h,
                          ),
                          Positioned(
                            top: 8.h,
                            child: Text(
                              "Done",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
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

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);

      if (particle.shape == 0) {
        // Rectangle confetti
        final rect = Rect.fromCenter(
          center: Offset.zero,
          width: particle.size * 3,
          height: particle.size,
        );
        canvas.drawRect(rect, paint);
      } else {
        // Diamond confetti
        final path = Path();
        path.moveTo(0, -particle.size * 1.5);
        path.lineTo(particle.size, 0);
        path.lineTo(0, particle.size * 1.5);
        path.lineTo(-particle.size, 0);
        path.close();
        canvas.drawPath(path, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
