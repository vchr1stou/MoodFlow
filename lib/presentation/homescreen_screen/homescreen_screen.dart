import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/app_bar/appbar_trailing_button.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../services/user_service.dart';
import '../breathingmain_screen/breathingmain_screen.dart';
import '../streak_screen/streak_screen.dart';
import '../profile_screen/profile_screen.dart';
import '../history_empty_screen/history_empty_screen.dart';
import '../discover_screen/discover_screen.dart';
import '../statistics_mood_charts_screen/statistics_mood_charts_screen.dart';
import '../log_input_screen/log_input_screen.dart';
import '../little_lifts_screen/little_lifts_screen.dart';
import '../ai_screen/ai_screen.dart';
import '../inhale_screen/inhale_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'models/homescreen_model.dart';
import 'provider/homescreen_provider.dart';

class NoSwipeBackRoute<T> extends MaterialPageRoute<T> {
  NoSwipeBackRoute({required WidgetBuilder builder}) : super(builder: builder);

  @override
  bool get hasScopedWillPopCallback => true;

  @override
  bool get canPop => false;

  @override
  bool get gestureEnabled => false;
}

class HomescreenScreen extends StatefulWidget {
  const HomescreenScreen({Key? key}) : super(key: key);

  @override
  HomescreenScreenState createState() => HomescreenScreenState();

  static Widget builder(BuildContext context) {
    return NoSwipeBackRoute(
      builder: (context) => const HomescreenScreen(),
    ).buildPage(
      context,
      Animation.fromValueListenable(
        ValueNotifier<double>(1),
      ),
      Animation.fromValueListenable(
        ValueNotifier<double>(0),
      ),
    );
  }
}

class HomescreenScreenState extends State<HomescreenScreen> {
  final UserService _userService = UserService();
  Map<String, Map<String, int>> _moodData = {};
  bool _isLoading = true;
  int _currentStreak = 0;

  @override
  void initState() {
    super.initState();
    print('HomescreenScreen initialized');
    // Load data immediately instead of waiting for post frame callback
    _loadMoodData();
    _calculateCurrentStreak();
    
    // Set up a timer to refresh the streak count periodically (every 5 minutes)
    Timer.periodic(Duration(minutes: 5), (timer) {
      if (mounted) {
        _calculateCurrentStreak();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    // Clean up timers or listeners if needed
    super.dispose();
  }

  Future<void> _loadMoodData() async {
    print('Starting to load mood data...');
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      print('Current user: ${user?.email}');
      
      if (user?.email == null) {
        print('No user email found, stopping load');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Get today and previous two days
      final now = DateTime.now();
      
      // Get logs for the whole week instead of just 3 days
      final dates = List.generate(7, (index) => now.subtract(Duration(days: index)));
      
      print('Fetching data for dates: ${dates.map((d) => DateFormat('dd_MM_yyyy').format(d)).join(', ')}');

      // Initialize mood data for each day
      for (var date in dates) {
        final dateStr = DateFormat('dd_MM_yyyy').format(date);
        _moodData[dateStr] = {
          'Heavy': 0,
          'Low': 0,
          'Neutral': 0,
          'Light': 0,
          'Bright': 0,
        };
      }

      // Query Firestore for logs
      final logsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.email)
          .collection('logs');

      print('Fetching logs from Firestore...');
      final querySnapshot = await logsRef.get();
      print('Retrieved ${querySnapshot.docs.length} logs');

      // Process each log
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final timestamp = data['timestamp'] as Timestamp?;
        if (timestamp == null) {
          print('Skipping log with no timestamp');
          continue;
        }

        final logDate = timestamp.toDate();
        final dateStr = DateFormat('dd_MM_yyyy').format(logDate);
        
        // Only process logs from the last 7 days
        if (!_moodData.containsKey(dateStr)) {
          print('Skipping log from date $dateStr (not in last 7 days)');
          continue;
        }

        final mood = data['mood'] as String?;
        if (mood == null) {
          print('Skipping log with no mood');
          continue;
        }

        // Extract mood name without emoji
        final moodName = mood.split(' ')[0];
        if (_moodData[dateStr]!.containsKey(moodName)) {
          _moodData[dateStr]![moodName] = (_moodData[dateStr]![moodName] ?? 0) + 1;
          print('Added mood $moodName for date $dateStr');
        }
      }

      // Debug output of mood data for each day
      _moodData.forEach((date, moods) {
        final total = moods.values.fold<int>(0, (sum, count) => sum + count);
        print('Date: $date - Total moods: $total');
        if (total > 0) {
          moods.forEach((mood, count) {
            if (count > 0) {
              print('  $mood: $count');
            }
          });
        }
      });

      // For specific weekdays, check if we have data
      final Map<String, String> weekdayToDate = {};
      for (int i = 0; i < 7; i++) {
        final weekday = now.subtract(Duration(days: now.weekday - 1 - i));
        final weekdayString = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][i];
        final dateStr = DateFormat('dd_MM_yyyy').format(weekday);
        weekdayToDate[weekdayString] = dateStr;
        
        final moods = _moodData[dateStr];
        if (moods != null) {
          final total = moods.values.fold<int>(0, (sum, count) => sum + count);
          print('$weekdayString ($dateStr): Total moods: $total');
        } else {
          print('$weekdayString ($dateStr): No data');
        }
      }

      print('Finished processing logs. Final mood data: $_moodData');
      setState(() {
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      print('Error loading mood data: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Calculate the current streak from Firestore logs
  Future<void> _calculateCurrentStreak() async {
    print('Calculating current streak from Firestore...');
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user?.email == null) {
        print('No user email found, cannot calculate streak');
        return;
      }

      // Get a reference to the logs collection
      final logsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.email)
          .collection('logs');
          
      // Get all logs
      final QuerySnapshot querySnapshot = await logsRef.get();
      print('Retrieved ${querySnapshot.docs.length} logs for streak calculation');
      
      if (querySnapshot.docs.isEmpty) {
        setState(() {
          _currentStreak = 0;
        });
        return;
      }
      
      // Parse dates from document IDs and store them
      Map<String, bool> daysWithLogs = {};
      for (var doc in querySnapshot.docs) {
        final docId = doc.id;
        
        // The document ID should be in format DD_MM_YYYY_time
        if (docId.contains('_')) {
          final parts = docId.split('_');
          if (parts.length >= 3) {
            try {
              final day = int.parse(parts[0]);
              final month = int.parse(parts[1]);
              final year = int.parse(parts[2]);
              
              // Create a unique key for each date
              final dateKey = '$day/$month/$year';
              daysWithLogs[dateKey] = true;
            } catch (e) {
              print('Error parsing date from docId $docId: $e');
            }
          }
        }
      }
      
      // Calculate streak by checking consecutive days
      final now = DateTime.now();
      int streak = 0;
      bool broken = false;
      
      // Start from today and go backwards
      for (int i = 0; i <= 100; i++) { // Limit to 100 days to avoid infinite loop
        final checkDate = now.subtract(Duration(days: i));
        final checkDay = checkDate.day;
        final checkMonth = checkDate.month;
        final checkYear = checkDate.year;
        
        // Create date key in the same format
        final dateKey = '$checkDay/$checkMonth/$checkYear';
        
        // Check if this day has a log
        final hasLog = daysWithLogs[dateKey] == true;
        
        if (hasLog) {
          streak++;
        } else {
          // If today doesn't have a log, that doesn't break the streak yet
          if (i > 0) {
            broken = true;
            break;
          }
        }
      }
      
      print('Current streak calculated: $streak days');
      setState(() {
        _currentStreak = streak;
      });
      
    } catch (e, stackTrace) {
      print('Error calculating streak: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        _currentStreak = 0;
      });
    }
  }

  double _calculateMoodValue(String dateStr) {
    if (!_moodData.containsKey(dateStr)) return 0.0;

    final moods = _moodData[dateStr]!;
    final total = moods.values.fold<int>(0, (sum, count) => sum + count);
    if (total == 0) return 0.0;

    // Calculate weighted average based on mood values
    // Heavy: 0, Low: 1, Neutral: 2, Light: 3, Bright: 4
    final weightedSum = (moods['Heavy']! * 0) +
        (moods['Low']! * 1) +
        (moods['Neutral']! * 2) +
        (moods['Light']! * 3) +
        (moods['Bright']! * 4);

    // Convert to a value between 0 and 1
    return weightedSum / (total * 4);
  }

  Color _getMoodColor(String dateStr) {
    if (!_moodData.containsKey(dateStr)) return Colors.white.withOpacity(0.3);

    final moods = _moodData[dateStr]!;
    final total = moods.values.fold<int>(0, (sum, count) => sum + count);
    if (total == 0) return Colors.white.withOpacity(0.3);

    // Find the most frequent mood
    String dominantMood = 'Neutral';
    int maxCount = 0;
    moods.forEach((mood, count) {
      if (count > maxCount) {
        maxCount = count;
        dominantMood = mood;
      }
    });

    // Return color based on dominant mood
    switch (dominantMood) {
      case 'Heavy':
        return Color(0xFF8C2C2A); // Heavy 😔
      case 'Low':
        return Color(0xFFA3444F); // Low 😕
      case 'Neutral':
        return Color(0xFFD78F5D); // Neutral 😐
      case 'Light':
        return Color(0xFFFFBE5B); // Light 😃
      case 'Bright':
        return Color(0xFFFFBC42); // Bright
      default:
        return Colors.white.withOpacity(0.3);
    }
  }

  Widget _buildStatBar(String day, double height, {bool isSelected = false}) {
    final now = DateTime.now();
    
    // Get the date for the specified day of this week
    // First get to the Monday of this week
    final mondayOfThisWeek = now.subtract(Duration(days: now.weekday - 1));
    
    // Then add days based on the specified day
    final dayOffset = {'Mon': 0, 'Tue': 1, 'Wed': 2, 'Thu': 3, 'Fri': 4, 'Sat': 5, 'Sun': 6}[day] ?? 0;
    final date = mondayOfThisWeek.add(Duration(days: dayOffset));
    
    final dateStr = DateFormat('dd_MM_yyyy').format(date);
    
    // Debug info
    print('Building bar for $day - Date: ${date.toString()} - DateStr: $dateStr');

    final isFutureDate = date.isAfter(now);
    final isToday = date.day == now.day && date.month == now.month && date.year == now.year;

    // Get mood data for this date if available
    final moods = _moodData[dateStr] ?? {
      'Heavy': 0,
      'Low': 0,
      'Neutral': 0,
      'Light': 0,
      'Bright': 0,
    };
    
    final total = moods.values.fold<int>(0, (sum, count) => sum + count);
    print('$day total moods: $total - $moods');
    
    final percentages = {
      'Heavy': moods['Heavy']! / (total > 0 ? total : 1),
      'Low': moods['Low']! / (total > 0 ? total : 1),
      'Neutral': moods['Neutral']! / (total > 0 ? total : 1),
      'Light': moods['Light']! / (total > 0 ? total : 1),
      'Bright': moods['Bright']! / (total > 0 ? total : 1),
    };
    
    // Use a consistent bar height for all days
    const double barHeight = 81.0; // 90 * 0.9

    // Find which moods are present (non-zero)
    final moodOrder = ['Bright', 'Light', 'Neutral', 'Low', 'Heavy'];
    final presentMoods = moodOrder.where((m) => percentages[m]! > 0 && moods[m]! > 0).toList();

    // Add a print statement to debug
    print('Building stat bar for $day (date: $dateStr): Total moods: $total');
    print('Present moods: $presentMoods');
    if (total > 0) {
      print('Mood percentages: $percentages');
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 90,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Background bar (always shown for visual consistency)
              Container(
                width: 30,
                height: barHeight,
                decoration: BoxDecoration(
                  color: isFutureDate || total == 0 
                      ? Colors.white.withOpacity(0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              // Stack mood segments only if we have data
              if (total > 0) ...[
                // Stack segments from bottom (Bright) to top (Heavy)
                ...(() {
                  List<Widget> segments = [];
                  double cumulativeHeight = 0;
                  
                  // Process moods from bottom to top
                  for (String mood in moodOrder) {
                    if (moods[mood]! > 0) {
                      final segmentHeight = barHeight * percentages[mood]!;
                      
                      segments.add(
                        Positioned(
                          bottom: cumulativeHeight,
                          child: Container(
                            width: 30,
                            height: segmentHeight,
                            decoration: BoxDecoration(
                              color: () {
                                switch (mood) {
                                  case 'Bright': return Color(0xFFFFBC42);
                                  case 'Light': return Color(0xFFFFBE5B);
                                  case 'Neutral': return Color(0xFFD78F5D);
                                  case 'Low': return Color(0xFFA3444F);
                                  case 'Heavy': return Color(0xFF8C2C2A);
                                  default: return Colors.transparent;
                                }
                              }(),
                              borderRadius: () {
                                // Only one segment: round both
                                if (presentMoods.length == 1) {
                                  return BorderRadius.circular(15);
                                }
                                // Bottom-most segment (first one we add)
                                if (cumulativeHeight == 0) {
                                  return BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  );
                                }
                                // Check if this is the top-most segment
                                if (mood == presentMoods.last) {
                                  return BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  );
                                }
                                // Middle segments: no rounding
                                return BorderRadius.zero;
                              }(),
                            ),
                          ),
                        ),
                      );
                      
                      // Add this segment's height to our running total
                      cumulativeHeight += segmentHeight;
                    }
                  }
                  return segments;
                })(),
              ],
            ],
          ),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            day,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsCard() {
    // Get current day of week (1-7, where 1 is Monday)
    final currentDay = DateTime.now().weekday;
    // Convert to 0-based index for our array (0-6)
    final currentDayIndex = currentDay - 1;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StatisticsMoodChartsScreen.builder(context),
          ),
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          double cardWidth = 340.0;
          double cardHeight = 205.0;
          double sideSpace = (constraints.maxWidth - cardWidth) / 2;

          return Container(
            width: constraints.maxWidth,
            height: cardHeight,
            child: Stack(
              children: [
                Positioned(
                  left: sideSpace,
                  child: SvgPicture.asset(
                    'assets/images/statistics_home_box.svg',
                    width: cardWidth,
                    height: cardHeight,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: sideSpace,
                  right: sideSpace,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Statistics',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        if (_isLoading)
                          Center(
                            child: CupertinoActivityIndicator(
                              color: Colors.white,
                              radius: 12,
                            ),
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatBar('Mon', 1.0, isSelected: currentDayIndex == 0),
                              _buildStatBar('Tue', 1.0, isSelected: currentDayIndex == 1),
                              _buildStatBar('Wed', 1.0, isSelected: currentDayIndex == 2),
                              _buildStatBar('Thu', 1.0, isSelected: currentDayIndex == 3),
                              _buildStatBar('Fri', 1.0, isSelected: currentDayIndex == 4),
                              _buildStatBar('Sat', 1.0, isSelected: currentDayIndex == 5),
                              _buildStatBar('Sun', 1.0, isSelected: currentDayIndex == 6),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      _buildHeader(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      _buildQuoteCard(),
                      SizedBox(height: 13),
                      Expanded(
                        flex: 2,
                        child: _buildFeelingCard(),
                      ),
                      SizedBox(height: 5),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: _buildStatisticsCard(),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -8),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            height: 69,
                            child: _buildActionButtons(),
                          ),
                        ),
                      ),
                      SizedBox(height: 23),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WELCOME BACK',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 0.5),
            StreamBuilder<DocumentSnapshot>(
              stream: _userService.getCurrentUserStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.exists) {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  final userName = userData['name'] as String? ?? 'User';
                  return Text(
                    userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                return Text(
                  'User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StreakScreen.builder(context),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: SvgPicture.asset(
                          'assets/images/streak_flame.svg',
                          width: 66,
                          height: 34,
                        ),
                      ),
                      Positioned(
                        top: 9.5,
                        left: 40,
                        child: Text(
                          '$_currentStreak',
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  width: 372,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Press and hold to start SOS',
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(
                              bottom: 100,
                              left: 20,
                              right: 20,
                            ),
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                          ),
                        );
                      },
                      onLongPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InhaleScreen.builder(context),
                            settings: RouteSettings(
                              arguments: {'duration': 1},
                            ),
                          ),
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/images/sos_button.svg',
                        width: 40,
                        height: 40,
                      ),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen.builder(context),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: SvgPicture.asset(
                          'assets/images/person.crop.circle.fill.svg',
                          width: 37,
                          height: 37,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuoteCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = 340.0;
        double cardHeight = 69.0;
        double sideSpace = (constraints.maxWidth - cardWidth) / 2;

        return Container(
          width: constraints.maxWidth,
          height: cardHeight,
          child: Stack(
            children: [
              Positioned(
                left: sideSpace,
                child: SvgPicture.asset(
                  'assets/images/quote.svg',
                  width: cardWidth,
                  height: cardHeight,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: sideSpace + 85,
                right: sideSpace + 40,
                top: 31,
                child: Text(
                  'Every step toward healing lights the path for someone else',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.0,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeelingCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = 340.0;
        double cardHeight = 219.0;
        double sideSpace = (constraints.maxWidth - cardWidth) / 2;

        return Container(
          width: constraints.maxWidth,
          height: cardHeight,
          child: Stack(
            children: [
              Positioned(
                left: sideSpace,
                child: SvgPicture.asset(
                  'assets/images/haf_box.svg',
                  width: cardWidth,
                  height: cardHeight,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: sideSpace,
                right: sideSpace,
                child: SizedBox(
                  height: cardHeight,
                  child: Padding(
                    padding: EdgeInsets.all(33),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'How are you feeling?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 27),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LogInputScreen.builder(
                                    context,
                                    source: 'homescreen'),
                              ),
                            );
                          },
                          child: Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.deepPurple,
                              size: 30,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = 340.0;
        double cardHeight = 69.0;
        double buttonWidth = 150.0;
        double buttonHeight = 40.0;
        double sideSpace = (constraints.maxWidth - cardWidth) / 2;

        return Container(
          width: constraints.maxWidth,
          height: cardHeight,
          child: Stack(
            children: [
              Positioned(
                left: sideSpace,
                child: SvgPicture.asset(
                  'assets/images/show_history_discovery_wrapper.svg',
                  width: cardWidth,
                  height: cardHeight,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: sideSpace,
                right: sideSpace,
                top: (cardHeight - buttonHeight) / 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => HistoryEmptyScreen(),
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/show_history_wrapper.svg',
                            width: buttonWidth,
                            height: buttonHeight,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Show History',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 4),
                              Padding(
                                padding: EdgeInsets.only(top: 0.8),
                                child: SvgPicture.asset(
                                  'assets/images/chevron_right.svg',
                                  width: 7,
                                  height: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiscoverScreen.builder(context),
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/show_history_wrapper.svg',
                            width: buttonWidth,
                            height: buttonHeight,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Discover',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 4),
                              Padding(
                                padding: EdgeInsets.only(top: 0.8),
                                child: SvgPicture.asset(
                                  'assets/images/chevron_right.svg',
                                  width: 7,
                                  height: 11,
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomNav() {
    // Check if running on Android and has system navigation bar
    final bottomPadding =
        Platform.isAndroid ? MediaQuery.of(context).padding.bottom : 0.0;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
          // Swiped right
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) =>
                  LittleLiftsScreen.builder(context),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      ),
                    ),
                    child: child,
                  ),
                );
              },
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: bottomPadding > 0 ? 20 + bottomPadding : 20),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Transform.translate(
              offset: Offset(0, -23),
              child: Stack(
                children: [
                  // The entire bottom bar SVG
                  SvgPicture.asset(
                    'assets/images/bottom_bar_home_pressed.svg',
                    fit: BoxFit.fitWidth,
                  ),

                  // Left side - Home text (no navigation)
                  // Increased width to make it easier to press
                  Positioned(
                    left: -20, // Extend touch area to the left
                    top: -10, // Extend touch area upward
                    bottom: -10, // Extend touch area downward
                    width:
                        200, // Increased from 150 to 200 for a wider touch target
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      // No onTap handler - tapping does nothing
                    ),
                  ),

                  // Right side - Little Lifts text (navigates to Little Lifts screen)
                  // Increased width to make it easier to press
                  Positioned(
                    right: -20, // Extend touch area to the right
                    top: -10, // Extend touch area upward
                    bottom: -10, // Extend touch area downward
                    width:
                        200, // Increased from 150 to 200 for a wider touch target
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              LittleLiftsScreen.builder(context),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale:
                                    Tween<double>(begin: 0.95, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOut,
                                  ),
                                ),
                                child: child,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: Offset(0, -25),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/ai_button.png',
                    width: 118.667,
                    height: 36,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    isAntiAlias: true,
                  ),
                  Positioned.fill(
                    top: -22,
                    bottom: -22,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              AiScreen.builder(context),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOut,
                                  ),
                                ),
                                child: child,
                              ),
                            );
                          },
                        ),
                      ),
                      child: Container(
                        color: Colors.transparent,
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

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildGlassButton({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
