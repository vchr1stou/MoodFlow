import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/animated_donut_chart.dart';
import '../statistics_mood_drivers_page/statistics_mood_drivers_page.dart';
import 'models/statistics_mood_charts_model.dart';
import 'provider/statistics_mood_charts_provider.dart';
import 'statisticsmood_tab_page.dart';
import 'package:table_calendar/table_calendar.dart';

class StatisticsMoodChartsScreen extends StatefulWidget {
  const StatisticsMoodChartsScreen({Key? key}) : super(key: key);

  @override
  StatisticsMoodChartsScreenState createState() =>
      StatisticsMoodChartsScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StatisticsMoodChartsProvider(),
      child: Builder(
        builder: (context) => StatisticsMoodChartsScreen(),
      ),
    );
  }
}

// ignore_for_file: must_be_immutable
class StatisticsMoodChartsScreenState extends State<StatisticsMoodChartsScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  String _selectedPeriod = 'Past Week';
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime _focusedDay = DateTime.now();
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  
  // Mood data
  Map<String, int> _moodCounts = {
    'Heavy': 0,
    'Low': 0,
    'Neutral': 0,
    'Light': 0,
    'Bright': 0,
  };
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadMoodData();
  }

  Future<void> _loadMoodData() async {
    print('DEBUG: Starting to load mood data');
    setState(() {
      _isLoading = true;
      _moodCounts = {
        'Heavy': 0,
        'Low': 0,
        'Neutral': 0,
        'Light': 0,
        'Bright': 0,
      };
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      print('DEBUG: Current user: ${user?.email}');
      if (user == null) {
        print('DEBUG: No user found');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final now = DateTime.now();
      print('DEBUG: Current date: $now');
      DateTime startDate;
      DateTime endDate;

      // Set date range based on selected period
      switch (_selectedPeriod) {
        case 'Past Week':
          // Set end time to 23:59:59 of today
          endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
          // Set start time to midnight of 7 days ago
          startDate = now.subtract(Duration(days: 7));
          startDate = DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
          break;
        case 'Past Month':
          // Set end time to 23:59:59 of today
          endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
          // Set start time to midnight of 30 days ago
          startDate = now.subtract(Duration(days: 30));
          startDate = DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
          break;
        case 'All Time':
          // Set end time to 23:59:59 of today
          endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
          // Set start time to a very old date (e.g., 10 years ago)
          startDate = DateTime(now.year - 10, now.month, now.day, 0, 0, 0);
          break;
        default:
          // Custom date range
          if (_rangeStart != null && _rangeEnd != null) {
            // Set start time to 00:00:00 of start date
            startDate = DateTime(_rangeStart!.year, _rangeStart!.month, _rangeStart!.day, 0, 0, 0);
            // Set end time to 23:59:59 of end date
            endDate = DateTime(_rangeEnd!.year, _rangeEnd!.month, _rangeEnd!.day, 23, 59, 59);
          } else {
            // Fallback to past week if custom range is not set
            endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
            startDate = now.subtract(Duration(days: 7));
            startDate = DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
          }
      }
      
      print('DEBUG: Querying logs from $startDate to $endDate');
      
      final logsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .collection('logs');

      // Get all logs and filter by timestamp
      final querySnapshot = await logsRef.get();
      
      print('DEBUG: Found ${querySnapshot.docs.length} total logs');

      // Filter logs by timestamp
      final filteredDocs = querySnapshot.docs.where((doc) {
        final data = doc.data();
        final timestamp = data['timestamp'] as Timestamp?;
        if (timestamp == null) return false;
        
        final logDate = timestamp.toDate();
        return logDate.isAfter(startDate) && logDate.isBefore(endDate);
      }).toList();

      print('DEBUG: Found ${filteredDocs.length} logs in date range');

      // Print all document IDs for debugging
      for (var doc in filteredDocs) {
        print('DEBUG: Found document with ID: ${doc.id}');
        final data = doc.data();
        print('DEBUG: Log data: $data');
        final mood = data['mood'] as String?;
        if (mood != null) {
          // Extract just the mood name without emoji
          final moodName = mood.split(' ')[0];
          print('DEBUG: Processing mood: $mood, extracted name: $moodName');
          if (_moodCounts.containsKey(moodName)) {
            _moodCounts[moodName] = (_moodCounts[moodName] ?? 0) + 1;
            print('DEBUG: Updated count for $moodName: ${_moodCounts[moodName]}');
          } else {
            print('DEBUG: Unknown mood name: $moodName');
          }
        }
      }

      print('DEBUG: Final mood counts: $_moodCounts');

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('DEBUG: Error loading mood data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<DonutSegment> _getMoodSegments() {
    final total = _moodCounts.values.fold<int>(0, (sum, count) => sum + count);
    print('DEBUG: Total mood count: $total');
    if (total == 0) {
      print('DEBUG: No mood data found, returning empty segments');
      return [
        DonutSegment(
          color: Colors.grey.withOpacity(0.5),
          value: 100,
          label: '',  // Empty label since we'll show the text in the center
        ),
      ];
    }

    final heavyPercent = (_moodCounts['Heavy'] ?? 0) * 100.0 / total;
    final lowPercent = (_moodCounts['Low'] ?? 0) * 100.0 / total;
    final neutralPercent = (_moodCounts['Neutral'] ?? 0) * 100.0 / total;
    final lightPercent = (_moodCounts['Light'] ?? 0) * 100.0 / total;
    final brightPercent = (_moodCounts['Bright'] ?? 0) * 100.0 / total;

    print('DEBUG: Mood Percentages:');
    print('DEBUG: Heavy: ${heavyPercent.toStringAsFixed(2)}%');
    print('DEBUG: Low: ${lowPercent.toStringAsFixed(2)}%');
    print('DEBUG: Neutral: ${neutralPercent.toStringAsFixed(2)}%');
    print('DEBUG: Light: ${lightPercent.toStringAsFixed(2)}%');
    print('DEBUG: Bright: ${brightPercent.toStringAsFixed(2)}%');

    return [
      DonutSegment(
        color: Color(0xFF8C2C2A), // Heavy
        value: heavyPercent,
        label: 'Heavy',
      ),
      DonutSegment(
        color: Color(0xFFA3444F), // Low
        value: lowPercent,
        label: 'Low',
      ),
      DonutSegment(
        color: Color(0xFFD78F5D), // Neutral
        value: neutralPercent,
        label: 'Neutral',
      ),
      DonutSegment(
        color: Color(0xFFFFC367), // Light (updated)
        value: lightPercent,
        label: 'Light',
      ),
      DonutSegment(
        color: Color(0xFFFFBC42), // Bright
        value: brightPercent,
        label: 'Bright',
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/chevron.backward.svg',
                                    width: 9,
                                    height: 17,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Back',
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Statistics',
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 660.h,
                      width: double.maxFinite,
                      margin: EdgeInsets.only(left: 6.h),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: double.maxFinite,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 8),
                                Expanded(
                                  child: Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      Center(
                                        child: SvgPicture.asset(
                                          'assets/images/statistics_box.svg',
                                          width: 379,
                                          height: 661,
                                        ),
                                      ),
                                      Positioned(
                                        top: 18,
                                        child: Column(
                                          children: [
                                            _buildTabview(context),
                                            SizedBox(height: 6),
                                          ],
                                        ),
                                      ),
                                      Positioned.fill(
                                        top: 62,
                                        child: PageView(
                                          controller: _pageController,
                                          onPageChanged: (index) {
                                            setState(() {
                                              _currentPage = index;
                                            });
                                          },
                                          physics: BouncingScrollPhysics(),
                                          pageSnapping: true,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 64),
                                                  Center(
                                                    child: _isLoading
                                                        ? CircularProgressIndicator()
                                                        : AnimatedDonutChart(
                                                            segments: _getMoodSegments(),
                                                            strokeWidth: 48,
                                                          ),
                                                  ),
                                                  Expanded(
                                                    child: StatisticsmoodTabPage.builder(context),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: StatisticsMoodDriversPage.builder(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              // Period Picker positioned 6 pixels down from picker_mood_charts_selected
              Positioned(
                top: 178, // moved further down
                left: 0,
                right: 0,
                child: Center(
                  child: _buildPeriodPicker(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabview(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/picker_mood_charts_selected.svg',
            width: 330,
            height: 44,
          ),
          Positioned(
            left: 30.5,
            top: 11,
            child: GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Text(
                "Mood Charts",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _currentPage == 0 ? Colors.white : Colors.white.withOpacity(0.85),
                ),
              ),
            ),
          ),
          Positioned(
            left: 193,
            top: 11,
            child: GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  1,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                width: 120,
                height: 24,
                child: Text(
                  "Mood Drivers",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _currentPage == 1 ? Colors.white : Colors.white.withOpacity(0.85),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodPicker(BuildContext context) {
    return Container(
      width: 330,
      height: 44,
      constraints: BoxConstraints(
        maxWidth: 330,
        maxHeight: 44,
      ),
      alignment: Alignment.center,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          print('DEBUG: Period picker container tapped');
          _showPeriodPicker(context);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background SVG
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                print('DEBUG: SVG background tapped');
                _showPeriodPicker(context);
              },
              child: SvgPicture.asset(
                'assets/images/statistics_period.svg',
                width: 330,
                height: 44,
                fit: BoxFit.contain,
              ),
            ),
            // Text on top
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                print('DEBUG: Period text tapped');
                _showPeriodPicker(context);
              },
              child: Text(
                _selectedPeriod,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 600,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: MediaQuery.of(context).size.height * 0.08,
        ),
        decoration: BoxDecoration(
          color: Color(0xFFBCBCBC).withOpacity(0.04),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 44,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  margin: EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          if (_rangeStart != null && _rangeEnd != null) {
                            setState(() {
                              _selectedPeriod =
                                  '${DateFormat('dd/MM/yyyy').format(_rangeStart!)} - ${DateFormat('dd/MM/yyyy').format(_rangeEnd!)}';
                            });
                            // Reload data with new date range
                            _loadMoodData();
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 12),
                        Text(
                          'From',
                          style: TextStyle(
                            color: const Color(0xFFFFFFFF),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height: 180,
                          child: CupertinoDatePicker(
                            initialDateTime: _rangeStart ?? DateTime.now(),
                            mode: CupertinoDatePickerMode.date,
                            onDateTimeChanged: (DateTime newDateTime) {
                              setState(() {
                                _rangeStart = newDateTime;
                                if (_rangeEnd != null && _rangeEnd!.isBefore(_rangeStart!)) {
                                  _rangeEnd = _rangeStart;
                                }
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'To',
                          style: TextStyle(
                            color: const Color(0xFFFFFFFF),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height: 180,
                          child: CupertinoDatePicker(
                            initialDateTime: _rangeEnd ?? DateTime.now(),
                            mode: CupertinoDatePickerMode.date,
                            onDateTimeChanged: (DateTime newDateTime) {
                              setState(() {
                                _rangeEnd = newDateTime;
                                if (_rangeStart != null && _rangeEnd!.isBefore(_rangeStart!)) {
                                  _rangeStart = _rangeEnd;
                                }
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPeriodPicker(BuildContext context) {
    print('DEBUG: _showPeriodPicker called');
    print('DEBUG: Current context: ${context.toString()}');
    
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        print('DEBUG: Building CupertinoModalPopup');
        return Container(
          height: 500,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: MediaQuery.of(context).size.height * 0.6,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFBCBCBC).withOpacity(0.04),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 44,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text(
                            'Done',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {
                            print('DEBUG: Done button pressed');
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          pickerTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      child: CupertinoPicker(
                        itemExtent: 40,
                        scrollController: FixedExtentScrollController(),
                        looping: false,
                        useMagnifier: true,
                        magnification: 1.2,
                        squeeze: 1.2,
                        backgroundColor: Colors.transparent,
                        selectionOverlay: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                              bottom: BorderSide(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        onSelectedItemChanged: (int index) {
                          print('DEBUG: Picker item changed to index: $index');
                          setState(() {
                            switch (index) {
                              case 0:
                                _selectedPeriod = 'Past Week';
                                break;
                              case 1:
                                _selectedPeriod = 'Past Month';
                                break;
                              case 2:
                                _selectedPeriod = 'All Time';
                                break;
                              case 3:
                                _selectedPeriod = 'Custom';
                                Navigator.of(context).pop();
                                _showCustomDatePicker(context);
                                break;
                            }
                          });
                          print('DEBUG: Selected period updated to: $_selectedPeriod');
                          // Reload data when period changes
                          _loadMoodData();
                        },
                        children: [
                          Center(
                            child: Text(
                              'Past Week',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Past Month',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'All Time',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Custom',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
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
          ),
        );
      },
    );
  }
}
