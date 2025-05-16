import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/streak_model.dart';
import 'provider/streak_provider.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class StreakScreen extends StatefulWidget {
  const StreakScreen({Key? key}) : super(key: key);

  @override
  StreakScreenState createState() => StreakScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StreakProvider(),
      child: Builder(
        builder: (context) => StreakScreen(),
      ),
    );
  }
}

class StreakScreenState extends State<StreakScreen> {
  // Map to store the days that have logs
  Map<String, bool> _daysWithLogs = {};
  // Always keep isLoading false since we don't want to show any loading indicator
  bool _isLoading = false;
  int _currentStreak = 0;
  int _longestStreak = 0;
  bool _loggedToday = false;
  String _timeUntilMidnight = "";
  Timer? _timer;
  
  // Pre-fetch logs before the widget is fully built for instant display
  Future<void> _preFetchLogs() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) return;
      
      // Get the current month and year
      final now = DateTime.now();
      final year = now.year;
      final month = now.month;
      final today = now.day;
      
      // Initialize an empty map to store which days have logs
      final daysWithLogs = <String, bool>{};
      
      // Get a reference to the logs collection
      final logsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .collection('logs');
          
      // Get all logs in the current month (no loading indicator)
      final QuerySnapshot querySnapshot = await logsRef.get();
      
      // Process logs
      for (var doc in querySnapshot.docs) {
        final docId = doc.id;
        
        if (docId.contains('_')) {
          final parts = docId.split('_');
          
          if (parts.length >= 3) {
            final day = int.tryParse(parts[0]);
            final docMonth = int.tryParse(parts[1]);
            final docYear = int.tryParse(parts[2]);
            
            if (docMonth == month && docYear == year && day != null) {
              final dayKey = day.toString().padLeft(2, '0');
              daysWithLogs['$dayKey'] = true;
              
              if (day == today) {
                _loggedToday = true;
              }
            }
          }
        }
      }
      
      // Calculate current streak
      await _calculateCurrentStreak(daysWithLogs);
      
      // Calculate longest streak by analyzing all logs
      await _calculateLongestStreak(user.email!);
      
      // Update state only once at the end
      if (mounted) {
        setState(() {
          _daysWithLogs = daysWithLogs;
        });
      }
    } catch (e) {
      print('Error pre-fetching logs: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );
    
    // Initialize time until midnight
    _calculateTimeUntilMidnight();
    
    // Start timer to update countdown
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _calculateTimeUntilMidnight();
    });
    
    // Pre-fetch logs for instant display
    _preFetchLogs();
  }

  // Calculate time until midnight
  void _calculateTimeUntilMidnight() {
    if (!mounted) return; // Add this check to prevent setState after dispose
    
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final difference = midnight.difference(now);
    
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    
    setState(() {
      _timeUntilMidnight = "$hours hours and $minutes minutes";
    });
  }

  // Calculate current streak
  Future<void> _calculateCurrentStreak(Map<String, bool> daysWithLogs) async {
    final now = DateTime.now();
    int streak = 0;
    bool broken = false;
    
    // Start from today and go backwards
    for (int i = 0; i <= 100; i++) {
      final checkDate = now.subtract(Duration(days: i));
      final checkDay = checkDate.day.toString().padLeft(2, '0');
      final checkMonth = checkDate.month;
      final checkYear = checkDate.year;
      
      // If we're checking a previous month, we need to query that month's logs
      if (checkMonth != now.month || checkYear != now.year) {
        break; // For simplicity, we'll stop at month boundaries for now
      }
      
      // Check if this day has a log
      final hasLog = daysWithLogs[checkDay] == true;
      
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
    
    if (mounted) {
      setState(() {
        _currentStreak = streak;
      });
      
      // Update the cached streak value
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('current_streak', streak);
    }
  }

  // Calculate longest streak by analyzing all logs
  Future<void> _calculateLongestStreak(String userEmail) async {
    try {
      print('Calculating longest streak...');
      
      // Get all logs for this user
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('logs')
          .get();
          
      if (querySnapshot.docs.isEmpty) {
        print('No logs found for longest streak calculation');
        if (mounted) {
          setState(() {
            _longestStreak = 0;
          });
        }
        return;
      }
      
      // Parse all log dates and sort them chronologically
      List<DateTime> logDates = [];
      
      for (var doc in querySnapshot.docs) {
        final docId = doc.id;
        
        if (docId.contains('_')) {
          final parts = docId.split('_');
          
          if (parts.length >= 3) {
            try {
              final day = int.parse(parts[0]);
              final month = int.parse(parts[1]);
              final year = int.parse(parts[2]);
              
              logDates.add(DateTime(year, month, day));
            } catch (e) {
              print('Error parsing date from docId $docId: $e');
            }
          }
        }
      }
      
      if (logDates.isEmpty) {
        print('No valid dates found in logs');
        if (mounted) {
          setState(() {
            _longestStreak = 0;
          });
        }
        return;
      }
      
      // Sort dates from oldest to newest
      logDates.sort((a, b) => a.compareTo(b));
      
      // Remove duplicate dates (multiple logs in the same day)
      final List<DateTime> uniqueLogDates = [];
      final Set<String> uniqueDates = {};
      
      for (var date in logDates) {
        final dateStr = DateFormat('yyyy-MM-dd').format(date);
        if (!uniqueDates.contains(dateStr)) {
          uniqueDates.add(dateStr);
          uniqueLogDates.add(date);
        }
      }
      
      // Handle the case with only one log date
      if (uniqueLogDates.length == 1) {
        print('Only one log date found, longest streak is 1');
        if (mounted) {
          setState(() {
            _longestStreak = 1;
          });
        }
        return;
      }
      
      // Calculate the longest streak by finding consecutive dates
      int currentStreak = 1;
      int longestStreak = 1;
      
      for (int i = 1; i < uniqueLogDates.length; i++) {
        // Check if this date is one day after the previous date
        final difference = uniqueLogDates[i].difference(uniqueLogDates[i - 1]).inDays;
        
        if (difference == 1) {
          // Consecutive day, increment current streak
          currentStreak++;
          // Update longest streak if current streak is longer
          longestStreak = currentStreak > longestStreak ? currentStreak : longestStreak;
        } else if (difference > 1) {
          // Break in streak, reset current streak
          currentStreak = 1;
        }
      }
      
      print('Longest streak calculated: $longestStreak days');
      
      // Save the longest streak
      if (mounted) {
        setState(() {
          _longestStreak = longestStreak;
        });
      }
      
      // Optionally save to Firestore for persistence
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .update({'longestStreak': longestStreak});
        print('Longest streak saved to Firestore');
      } catch (e) {
        print('Error saving longest streak to Firestore: $e');
      }
      
    } catch (e) {
      print('Error calculating longest streak: $e');
    }
  }

  @override
  void dispose() {
    // Cancel the timer to prevent memory leaks
    _timer?.cancel();
    
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  void _handleCloseButton() {
    Navigator.of(context).pop();
  }

  // Get days in month for the calendar
  List<DateTime> _getDaysInMonth(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
    
    // Calculate days to include from previous month to start from Monday
    final firstWeekday = firstDayOfMonth.weekday;
    final daysFromPreviousMonth = firstWeekday == 1 ? 0 : firstWeekday - 1;
    
    final firstDate = firstDayOfMonth.subtract(Duration(days: daysFromPreviousMonth));
    
    // We'll show 6 weeks (42 days) to ensure we have enough rows
    final daysToGenerate = 42;
    
    return List.generate(
      daysToGenerate,
      (index) => firstDate.add(Duration(days: index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get current month and year
    final now = DateTime.now();
    String currentMonthYear = DateFormat('MMMM yyyy').format(now);
    final daysInMonth = _getDaysInMonth(now);
    final dayLabels = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            // Background Image
            Container(
              width: double.maxFinite,
              height: double.maxFinite,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
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
            // Close Button
            Positioned(
              top: 62.h,
              right: 15.h,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 35,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: _handleCloseButton,
                  child: SvgPicture.asset(
                    'assets/images/close_button.svg',
                    width: 39.h,
                    height: 39.h,
                  ),
                ),
              ),
            ),
            // Streak Flame - moved up from 130.h to 100.h
            Positioned(
              top: 100.h,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Center(
                    child: SvgPicture.asset(
                      'assets/images/flame.svg',
                      width: 112.h,
                      height: 154.h,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.h),
                    child: Text(
                      "A streak is your mood-tracking winning spree! 🤩\nEach day you log your mood, you keep the chain alive,\nthink of it as collecting little victories for your mind!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  // Streak Bubbles
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Left bubble
                      Container(
                        width: 157.h,
                        height: 67.h,
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/images/bubble_streak.svg',
                              width: 157.h,
                              height: 67.h,
                            ),
                            Positioned(
                              top: 8.h,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  Text(
                                    "Longest Streak",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    "$_longestStreak days",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Right bubble
                      Container(
                        width: 157.h,
                        height: 67.h,
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/images/bubble_streak.svg',
                              width: 157.h,
                              height: 67.h,
                            ),
                            Positioned(
                              top: 8.h,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  Text(
                                    "Current Streak",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    "$_currentStreak days",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Alert streak
                  SizedBox(height: 15.h), 
                  Center(
                    child: Container(
                      width: 340.h,
                      height: 51.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/alert_streak.svg',
                            width: 340.h,
                            height: 51.h,
                          ),
                          Text(
                            _loggedToday 
                              ? "✅ Streak saved. Small steps, steady growth—you're showing up for yourself."
                              : "⏰ Quick! $_timeUntilMidnight until 23:59.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Calendar Box
                  SizedBox(height: 15.h), 
                  Center(
                    child: Stack(
                      children: [
                        SvgPicture.asset(
                          'assets/images/calendar_box.svg',
                          width: 354.h,
                          height: 314.h,
                        ),
                        // Month Year overlay - 16p down from top of calendar box
                        Positioned(
                          top: 16.h,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/month_year.svg',
                                  width: 132.h,
                                  height: 23.h,
                                ),
                                Text(
                                  currentMonthYear,
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Calendar grid - moved higher up
                        Positioned(
                          top: 50.h,
                          left: 20.h,
                          right: 20.h,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Custom calendar with minimal spacing between headers and numbers
                              Container(
                                height: 230.h,
                                child: Column(
                                  children: [
                                    // Day headers with minimal height
                                    Container(
                                      height: 25.h,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: dayLabels.map((day) => Text(
                                          day,
                                          style: GoogleFonts.roboto(
                                            color: Colors.white.withOpacity(0.3),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )).toList(),
                                      ),
                                    ),
                                    // Date grid with increased spacing between numbers
                                    Expanded(
                                      child: GridView.builder(
                                        padding: EdgeInsets.only(top: 1.h),
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 7,
                                          childAspectRatio: 1.1,
                                          mainAxisSpacing: 8.h, // Increased vertical spacing between numbers
                                          crossAxisSpacing: 5.h,
                                        ),
                                        itemCount: daysInMonth.length,
                                        itemBuilder: (context, index) {
                                          final date = daysInMonth[index];
                                          final isCurrentMonth = date.month == now.month;
                                          
                                          // Format the day to check against our logs map
                                          final dayString = date.day.toString().padLeft(2, '0');
                                          
                                          // Check if this day has a log entry
                                          final hasLog = _daysWithLogs[dayString] == true && isCurrentMonth;
                                          
                                          return Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              // Orange circle for days with logs
                                              if (hasLog)
                                                Container(
                                                  width: 30.h,
                                                  height: 30.h,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFFF9500).withOpacity(0.6),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              // Day number
                                              Text(
                                                date.day.toString(),
                                                style: GoogleFonts.roboto(
                                                  color: isCurrentMonth 
                                                    ? Colors.white 
                                                    : Colors.white.withOpacity(0.3),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
}
