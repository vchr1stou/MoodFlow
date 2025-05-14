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
  bool _isLoading = false; // Changed to false by default to avoid showing loading indicator

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
    
    // Fetch logs for the current month without showing loading indicator
    _fetchLogsForCurrentMonth();
  }

  // Fetch logs for the current month
  Future<void> _fetchLogsForCurrentMonth() async {
    print('===== STARTING LOG FETCH =====');
    // Not setting isLoading to true anymore
    
    try {
      print('Checking for current user...');
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        print('ERROR: No user logged in or email is null');
        return;
      }
      
      print('Current user email: ${user.email}');
      
      // Get the current month and year
      final now = DateTime.now();
      final year = now.year;
      final month = now.month;
      print('Fetching logs for month: $month, year: $year');
      
      // Initialize an empty map to store which days have logs
      final daysWithLogs = <String, bool>{};
      
      try {
        // Get a reference to the logs collection
        print('Creating reference to collection: users/${user.email}/logs');
        
        // Check if the collection exists by getting the document count
        final logsRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('logs');
            
        // Get all logs in the current month
        print('Executing Firestore query...');
        final QuerySnapshot querySnapshot = await logsRef.get();
        print('Query completed. Found ${querySnapshot.docs.length} log documents');
        
        // For debugging - add a mock document if none found
        if (querySnapshot.docs.isEmpty) {
          print('No documents found in logs collection. Creating mock data for testing...');
          
          // Format the current day as a two-digit string
          final currentDay = now.day.toString().padLeft(2, '0');
          daysWithLogs[currentDay] = true;
        } else {
          // Loop through each log document
          for (var doc in querySnapshot.docs) {
            final docId = doc.id;
            print('Processing document: $docId');
            
            // The document ID should be in format DD_MM_YYYY_time
            // Extract the date part
            if (docId.contains('_')) {
              final parts = docId.split('_');
              print('Split parts: $parts');
              
              if (parts.length >= 3) {
                final day = int.tryParse(parts[0]);
                final docMonth = int.tryParse(parts[1]);
                final docYear = int.tryParse(parts[2]);
                
                print('Parsed date: day=$day, month=$docMonth, year=$docYear');
                
                // If this log is from the current month and year
                if (docMonth == month && docYear == year && day != null) {
                  // Format the day key (always 2 digits)
                  final dayKey = day.toString().padLeft(2, '0');
                  
                  // Mark this day as having a log
                  daysWithLogs['$dayKey'] = true;
                  print('Found log for day $dayKey');
                } else {
                  print('Document date does not match current month/year');
                }
              } else {
                print('Document ID does not have enough parts: $docId');
              }
            } else {
              print('Document ID does not contain underscore: $docId');
            }
          }
        }
      } catch (firebaseError) {
        print('Error querying Firestore: $firebaseError');
        // Even if there's an error, we'll continue without showing a loading indicator
      }
      
      print('Days with logs: $daysWithLogs');
      
      // Only update state if we found logs
      if (daysWithLogs.isNotEmpty) {
        setState(() {
          _daysWithLogs = daysWithLogs;
        });
      }
      print('===== COMPLETED LOG FETCH SUCCESSFULLY =====');
    } catch (e, stackTrace) {
      print('ERROR fetching logs: $e');
      print('Stack trace: $stackTrace');
      print('===== LOG FETCH FAILED =====');
      // Not updating the UI state on error
    }
  }

  @override
  void dispose() {
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
                                    "20 days",
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
                                    "20 days",
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
                            "⏰ Quick! 7 hours left to save your streak!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 13,
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
