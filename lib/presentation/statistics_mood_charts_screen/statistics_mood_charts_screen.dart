import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'dart:typed_data';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
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
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import '../../core/services/storage_service.dart';

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
  String _selectedMood = 'Bright ☺️';
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

  // Mood image mapping
  static const List<Map<String, String>> moodImageRows = [
    { 'mood': 'Bright',  'asset': 'emoji_star_struck.png' },
    { 'mood': 'Light',   'asset': 'light.png' },
    { 'mood': 'Neutral', 'asset': 'neutral.png' },
    { 'mood': 'Low',     'asset': 'low.png' },
    { 'mood': 'Heavy',   'asset': 'heavy.png' },
  ];

  // Helper: mood to numeric value
  static const Map<String, int> moodToValue = {
    'Heavy': 0,
    'Low': 1,
    'Neutral': 2,
    'Light': 3,
    'Bright': 4,
  };
  static const List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // Store mood logs for the week/month
  List<List<int>> _weeklyMoodValues = List.generate(7, (_) => []);
  List<double> _weeklyMoodAverages = List.filled(7, 0);
  List<DateTime> _weekDates = List.generate(7, (index) => DateTime.now().subtract(Duration(days: 6 - index)));
  
  // Store mood logs for the month
  List<List<int>> _monthlyMoodValues = List.generate(30, (_) => []);
  List<double> _monthlyMoodAverages = List.filled(30, 0);
  List<DateTime> _monthDates = List.generate(30, (index) => DateTime.now().subtract(Duration(days: 29 - index)));

  // Store mood logs for all time
  List<List<int>> _allTimeMoodValues = [];
  List<double> _allTimeMoodAverages = [];
  List<DateTime> _allTimeDates = [];
  String _allTimePeriod = 'months'; // 'months' or 'years'

  // Store mood logs for custom range
  List<List<int>> _customMoodValues = [];
  List<double> _customMoodAverages = [];
  List<DateTime> _customDates = [];
  String _customPeriod = 'days'; // 'days', 'weeks', 'months', or 'years'

  // Add new state variables
  Map<String, int> _whatsHappeningCounts = {};
  Map<String, int> _locationCounts = {};
  Map<String, int> _contactCounts = {};
  bool _isLoadingCorrelations = false;
  List<Map<String, dynamic>> _rawLogs = [];
  // Add new state variables at the top of the class
  Map<String, int> _positiveMoodActivities = {};
  List<MapEntry<String, int>> _topPositiveActivities = [];
  Map<String, int> _negativeMoodActivities = {};
  List<MapEntry<String, int>> _topNegativeActivities = [];

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
          startDate = now.subtract(Duration(days: 6));
          startDate = DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
          
          // Update week dates for display
          _weekDates = List.generate(7, (index) => startDate.add(Duration(days: index)));
          break;
        case 'Past Month':
          // Set end time to 23:59:59 of today
          endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
          // Set start time to midnight of 30 days ago
          startDate = now.subtract(Duration(days: 29));
          startDate = DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
          
          // Update month dates for display
          _monthDates = List.generate(30, (index) => startDate.add(Duration(days: index)));
          
          // Reset monthly mood values
          _monthlyMoodValues = List.generate(30, (_) => []);
          _monthlyMoodAverages = List.filled(30, 0);
          break;
        case 'All Time':
          // Set end time to 23:59:59 of today
          endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
          // Set start time to a very old date (e.g., 10 years ago)
          startDate = DateTime(now.year - 10, now.month, now.day, 0, 0, 0);
          
          // Reset all time mood values
          _allTimeMoodValues = [];
          _allTimeMoodAverages = [];
          _allTimeDates = [];
          break;
        case 'Custom':
          if (_rangeStart != null && _rangeEnd != null) {
            // Set start time to 00:00:00 of start date
            startDate = DateTime(_rangeStart!.year, _rangeStart!.month, _rangeStart!.day, 0, 0, 0);
            // Set end time to 23:59:59 of end date
            endDate = DateTime(_rangeEnd!.year, _rangeEnd!.month, _rangeEnd!.day, 23, 59, 59);
            
            // Reset custom mood values
            _customMoodValues = [];
            _customMoodAverages = [];
            _customDates = [];
            
            // Determine the appropriate period based on the date range
            final daysDifference = endDate.difference(startDate).inDays;
            if (daysDifference <= 7) {
              _customPeriod = 'days';
            } else if (daysDifference <= 31) {
              _customPeriod = 'weeks';
            } else if (daysDifference <= 365) {
              _customPeriod = 'months';
            } else {
              _customPeriod = 'years';
            }
          } else {
            // Fallback to past week if custom range is not set
            endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
            startDate = now.subtract(Duration(days: 6));
            startDate = DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
          }
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

      // Reset weekly mood values
      _weeklyMoodValues = List.generate(7, (_) => []);
      _weeklyMoodAverages = List.filled(7, 0);

      // Print all document IDs for debugging
      for (var doc in filteredDocs) {
        print('DEBUG: Found document with ID: ${doc.id}');
        final data = doc.data();
        print('DEBUG: Log data: $data');
        final mood = data['mood'] as String?;
        if (mood != null) {
          final moodName = mood.split(' ')[0];
          if (_moodCounts.containsKey(moodName)) {
            _moodCounts[moodName] = (_moodCounts[moodName] ?? 0) + 1;
          }
          
          // For all graph types: collect mood values
          if ((_selectedPeriod == 'Past Week' || _selectedPeriod == 'Past Month' || 
               _selectedPeriod == 'All Time' || _selectedPeriod == 'Custom') && 
              moodToValue.containsKey(moodName)) {
            final timestamp = data['timestamp'] as Timestamp?;
            if (timestamp != null) {
              final logDate = timestamp.toDate();
              if (_selectedPeriod == 'Past Week') {
                int weekday = logDate.weekday;
                _weeklyMoodValues[weekday-1].add(moodToValue[moodName]!);
              } else if (_selectedPeriod == 'Past Month') {
                int daysFromStart = logDate.difference(startDate).inDays;
                if (daysFromStart >= 0 && daysFromStart < 30) {
                  _monthlyMoodValues[daysFromStart].add(moodToValue[moodName]!);
                }
              } else if (_selectedPeriod == 'All Time') {
                DateTime periodDate;
                if (logDate.year == now.year) {
                  periodDate = DateTime(logDate.year, logDate.month, 1);
                  _allTimePeriod = 'months';
                } else {
                  periodDate = DateTime(logDate.year, 1, 1);
                  _allTimePeriod = 'years';
                }
                
                int periodIndex = _allTimeDates.indexWhere((date) => 
                  _allTimePeriod == 'months' 
                    ? (date.year == periodDate.year && date.month == periodDate.month)
                    : (date.year == periodDate.year)
                );
                
                if (periodIndex == -1) {
                  _allTimeDates.add(periodDate);
                  _allTimeMoodValues.add([]);
                  periodIndex = _allTimeDates.length - 1;
                }
                
                _allTimeMoodValues[periodIndex].add(moodToValue[moodName]!);
              } else if (_selectedPeriod == 'Custom') {
                DateTime periodDate;
                switch (_customPeriod) {
                  case 'days':
                    periodDate = DateTime(logDate.year, logDate.month, logDate.day);
                    break;
                  case 'weeks':
                    // Get the Monday of the week
                    final weekDay = logDate.weekday;
                    periodDate = logDate.subtract(Duration(days: weekDay - 1));
                    periodDate = DateTime(periodDate.year, periodDate.month, periodDate.day);
                    break;
                  case 'months':
                    periodDate = DateTime(logDate.year, logDate.month, 1);
                    break;
                  case 'years':
                    periodDate = DateTime(logDate.year, 1, 1);
                    break;
                  default:
                    periodDate = DateTime(logDate.year, logDate.month, logDate.day);
                }
                
                int periodIndex = _customDates.indexWhere((date) {
                  switch (_customPeriod) {
                    case 'days':
                      return date.year == periodDate.year && 
                             date.month == periodDate.month && 
                             date.day == periodDate.day;
                    case 'weeks':
                      return date.year == periodDate.year && 
                             date.month == periodDate.month && 
                             date.day == periodDate.day;
                    case 'months':
                      return date.year == periodDate.year && 
                             date.month == periodDate.month;
                    case 'years':
                      return date.year == periodDate.year;
                    default:
                      return false;
                  }
                });
                
                if (periodIndex == -1) {
                  _customDates.add(periodDate);
                  _customMoodValues.add([]);
                  periodIndex = _customDates.length - 1;
                }
                
                _customMoodValues[periodIndex].add(moodToValue[moodName]!);
              }
            }
          }
        }
      }

      // Calculate averages for each period
      if (_selectedPeriod == 'Past Week') {
        for (int i = 0; i < 7; i++) {
          if (_weeklyMoodValues[i].isNotEmpty) {
            _weeklyMoodAverages[i] = _weeklyMoodValues[i].reduce((a, b) => a + b) / _weeklyMoodValues[i].length;
          } else {
            _weeklyMoodAverages[i] = double.nan;
          }
        }
      } else if (_selectedPeriod == 'Past Month') {
        for (int i = 0; i < 30; i++) {
          if (_monthlyMoodValues[i].isNotEmpty) {
            _monthlyMoodAverages[i] = _monthlyMoodValues[i].reduce((a, b) => a + b) / _monthlyMoodValues[i].length;
          } else {
            _monthlyMoodAverages[i] = double.nan;
          }
        }
      } else if (_selectedPeriod == 'All Time') {
        final sortedIndices = List<int>.generate(_allTimeDates.length, (i) => i)
          ..sort((a, b) => _allTimeDates[a].compareTo(_allTimeDates[b]));
        
        _allTimeDates = sortedIndices.map((i) => _allTimeDates[i]).toList();
        _allTimeMoodValues = sortedIndices.map((i) => _allTimeMoodValues[i]).toList();
        
        _allTimeMoodAverages = _allTimeMoodValues.map((values) {
          if (values.isEmpty) return double.nan;
          return values.reduce((a, b) => a + b) / values.length;
        }).toList();
      } else if (_selectedPeriod == 'Custom') {
        final sortedIndices = List<int>.generate(_customDates.length, (i) => i)
          ..sort((a, b) => _customDates[a].compareTo(_customDates[b]));
        
        _customDates = sortedIndices.map((i) => _customDates[i]).toList();
        _customMoodValues = sortedIndices.map((i) => _customMoodValues[i]).toList();
        
        _customMoodAverages = _customMoodValues.map((values) {
          if (values.isEmpty) return double.nan;
          return values.reduce((a, b) => a + b) / values.length;
        }).toList();
      }

      print('DEBUG: Final mood counts: $_moodCounts');

      // Add this at the end of the method
      if (_selectedPeriod == 'Past Week') {
        print('DEBUG: Selected period is Past Week, calling _analyzeMoodCorrelations');
        await _analyzeMoodCorrelations();
      } else {
        print('DEBUG: Selected period is $_selectedPeriod, skipping _analyzeMoodCorrelations');
      }

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
                      height: ScreenUtil().setHeight(660),
                      width: double.maxFinite,
                      margin: EdgeInsets.only(left: ScreenUtil().setHeight(6)),
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
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SvgPicture.asset(
                                          'assets/images/statistics_box.svg',
                                          width: 379,
                                          height: 661,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 18,
                                        left: 0,
                                        right: 0,
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
                                          physics: NeverScrollableScrollPhysics(),
                                          pageSnapping: true,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 64),
                                                  if (_currentPage == 0) ...[
                                                  Center(
                                                    child: AnimatedDonutChart(
                                                      segments: _getMoodSegments(),
                                                      strokeWidth: 48,
                                                    ),
                                                  ),
                                                  SizedBox(height: 20),
                                                  if (_selectedPeriod == 'Past Week' || _selectedPeriod == 'Past Month' || 
                                                      _selectedPeriod == 'All Time' || _selectedPeriod == 'Custom')
                                                    Column(
                                                      children: [
                                                        Stack(
                                                          alignment: Alignment.center,
                                                          children: [
                                                            SvgPicture.asset(
                                                              'assets/images/graph_box.svg',
                                                              width: 352,
                                                              height: 218,
                                                            ),
                                                            Positioned(
                                                              top: 38,
                                                              child: SizedBox(
                                                                width: 300,
                                                                height: 200,
                                                                child: Stack(
                                                                  alignment: Alignment.center,
                                                                  children: [
                                                                    if (_selectedPeriod == 'Past Week' && _weeklyMoodValues.every((values) => values.isEmpty) ||
                                                                        _selectedPeriod == 'Past Month' && _monthlyMoodValues.every((values) => values.isEmpty) ||
                                                                        _selectedPeriod == 'All Time' && _allTimeMoodValues.every((values) => values.isEmpty) ||
                                                                        _selectedPeriod == 'Custom' && _customMoodValues.every((values) => values.isEmpty))
                                                                      Center(
                                                                        child: Text(
                                                                          'No data available',
                                                                          style: GoogleFonts.roboto(
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.white,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    else
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(bottom: 40.0),
                                                                        child: LineChart(
                                                                          LineChartData(
                                                                            minY: 0,
                                                                            maxY: 4,
                                                                            titlesData: FlTitlesData(
                                                                              leftTitles: AxisTitles(
                                                                                sideTitles: SideTitles(
                                                                                  showTitles: true,
                                                                                  interval: 1,
                                                                                  getTitlesWidget: (value, meta) {
                                                                                    final moods = ['😔', '😕', '😐', '😃', '😊'];
                                                                                    if (value % 1 == 0 && value >= 0 && value <= 4) {
                                                                                      return Padding(
                                                                                        padding: const EdgeInsets.only(bottom: 8.0),
                                                                                        child: Text(moods[value.toInt()], style: TextStyle(color: Colors.white, fontSize: 18)),
                                                                                      );
                                                                                    }
                                                                                    return Container();
                                                                                  },
                                                                                  reservedSize: 32,
                                                                                ),
                                                                              ),
                                                                              bottomTitles: AxisTitles(
                                                                                sideTitles: SideTitles(
                                                                                  showTitles: true,
                                                                                  interval: _selectedPeriod == 'Past Week' ? 1 : 
                                                                                           _selectedPeriod == 'Past Month' ? 5 : 
                                                                                           _selectedPeriod == 'Custom' ? 
                                                                                             (_customPeriod == 'days' ? 1 :
                                                                                              _customPeriod == 'weeks' ? 1 :
                                                                                              _customPeriod == 'months' ? 1 : 1) :
                                                                                           _allTimePeriod == 'months' ? 1 : 1,
                                                                                  reservedSize: 30,
                                                                                  getTitlesWidget: (value, meta) {
                                                                                    if (_selectedPeriod == 'Past Week' && value >= 0 && value < 7) {
                                                                                      return Padding(
                                                                                        padding: const EdgeInsets.only(top: 8.0),
                                                                                        child: Text(_getDayLabel(value.toInt()), style: TextStyle(color: Colors.white, fontSize: 14)),
                                                                                      );
                                                                                    } else if (_selectedPeriod == 'Past Month' && value >= 0 && value < 30) {
                                                                                      return Padding(
                                                                                        padding: const EdgeInsets.only(top: 8.0),
                                                                                        child: Text(_getDayLabel(value.toInt()), style: TextStyle(color: Colors.white, fontSize: 14)),
                                                                                      );
                                                                                    } else if (_selectedPeriod == 'All Time' && value >= 0 && value < _allTimeDates.length) {
                                                                                      return Padding(
                                                                                        padding: const EdgeInsets.only(top: 8.0),
                                                                                        child: Text(_getDayLabel(value.toInt()), style: TextStyle(color: Colors.white, fontSize: 14)),
                                                                                      );
                                                                                    } else if (_selectedPeriod == 'Custom' && value >= 0 && value < _customDates.length) {
                                                                                      return Padding(
                                                                                        padding: const EdgeInsets.only(top: 8.0),
                                                                                        child: Text(_getDayLabel(value.toInt()), style: TextStyle(color: Colors.white, fontSize: 14)),
                                                                                      );
                                                                                    }
                                                                                    return Container();
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                                            ),
                                                                            gridData: FlGridData(
                                                                              show: true,
                                                                              horizontalInterval: 1,
                                                                              verticalInterval: _selectedPeriod == 'Past Week' ? 1 : 
                                                                                               _selectedPeriod == 'Past Month' ? 5 : 
                                                                                               _selectedPeriod == 'Custom' ? 
                                                                                                 (_customPeriod == 'days' ? 1 :
                                                                                                  _customPeriod == 'weeks' ? 1 :
                                                                                                  _customPeriod == 'months' ? 1 : 1) :
                                                                                               _allTimePeriod == 'months' ? 1 : 1,
                                                                              getDrawingHorizontalLine: (value) => FlLine(
                                                                                color: Colors.white24,
                                                                                strokeWidth: 1,
                                                                                dashArray: [5, 5],
                                                                              ),
                                                                              getDrawingVerticalLine: (value) => FlLine(
                                                                                color: Colors.white24,
                                                                                strokeWidth: 1,
                                                                                dashArray: [5, 5],
                                                                              ),
                                                                            ),
                                                                            borderData: FlBorderData(show: false),
                                                                            lineBarsData: [
                                                                              LineChartBarData(
                                                                                spots: [
                                                                                  for (int i = 0; i < (_selectedPeriod == 'Past Week' ? 7 : 
                                                                                                     _selectedPeriod == 'Past Month' ? 30 : 
                                                                                                     _selectedPeriod == 'Custom' ? _customDates.length :
                                                                                                     _allTimeDates.length); i++)
                                                                                    if (!(_selectedPeriod == 'Past Week' ? _weeklyMoodAverages[i] : 
                                                                                          _selectedPeriod == 'Past Month' ? _monthlyMoodAverages[i] : 
                                                                                          _selectedPeriod == 'Custom' ? _customMoodAverages[i] :
                                                                                          _allTimeMoodAverages[i]).isNaN)
                                                                                      FlSpot(i.toDouble(), _selectedPeriod == 'Past Week' ? _weeklyMoodAverages[i] : 
                                                                                                          _selectedPeriod == 'Past Month' ? _monthlyMoodAverages[i] : 
                                                                                                          _selectedPeriod == 'Custom' ? _customMoodAverages[i] :
                                                                                                          _allTimeMoodAverages[i])
                                                                                ],
                                                                                isCurved: true,
                                                                                color: Colors.amberAccent,
                                                                                barWidth: 4,
                                                                                dotData: FlDotData(show: true),
                                                                                belowBarData: BarAreaData(show: false),
                                                                              ),
                                                                            ],
                                                                            lineTouchData: LineTouchData(
                                                                              enabled: false,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 11),
                                                        GestureDetector(
                                                          onTap: _exportChartsToPDF,
                                                          child: Stack(
                                                            alignment: Alignment.center,
                                                            children: [
                                                              SvgPicture.asset(
                                                                'assets/images/export_charts.svg',
                                                                width: 141,
                                                                height: 36,
                                                              ),
                                                              Positioned(
                                                                top: 7,
                                                                child: Text(
                                                                  'Export Charts',
                                                                  style: GoogleFonts.roboto(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                  SizedBox(height: 18),
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
                  child: Column(
                    children: [
                      _buildPeriodPicker(context),
                      if (_currentPage == 1) ...[
                        SizedBox(height: 6),
                        Container(
                          height: 41,
                          margin: EdgeInsets.only(top: 2),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/understand_whats.svg',
                                width: 352,
                                height: 41,
                              ),
                              Positioned(
                                top: 8,
                                child: Text(
                                  "Understand what's shaping your mood",
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2),
                        _buildImproveMoodOverlay(),
                        SizedBox(height: 10),
                        _buildNegativeMoodOverlay(),
                        SizedBox(height: 10),
                        _buildCorrelationOverlay(),
                      ],
                    ],
                  ),
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
            _currentPage == 0 
                ? 'assets/images/picker_mood_charts_selected.svg'
                : 'assets/images/picker_mood_drivers_selected.svg',
            width: 330,
            height: 44,
          ),
          Positioned(
            left: 30.5,
            top: 11,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentPage = 0;
                });
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
                setState(() {
                  _currentPage = 1;
                });
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
                          // Also trigger correlation analysis
                          _analyzeMoodCorrelations();
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

  String _getDayLabel(int index) {
    if (_selectedPeriod == 'Past Week') {
      final date = _weekDates[index];
      final today = DateTime.now();
      final yesterday = today.subtract(Duration(days: 1));
      
      if (date.year == today.year && date.month == today.month && date.day == today.day) {
        return 'Tdy';
      } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
        return 'Yst';
      } else {
        return DateFormat('EEE').format(date);
      }
    } else if (_selectedPeriod == 'Past Month') {
      final date = _monthDates[index];
      final today = DateTime.now();
      final yesterday = today.subtract(Duration(days: 1));
      
      if (date.year == today.year && date.month == today.month && date.day == today.day) {
        return 'Tdy';
      } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
        return 'Yst';
      } else {
        return DateFormat('d').format(date);
      }
    } else if (_selectedPeriod == 'All Time') {
      if (_allTimeDates.isEmpty) return '';
      final date = _allTimeDates[index];
      if (_allTimePeriod == 'months') {
        return DateFormat('MMM').format(date);
      } else {
        return DateFormat('yyyy').format(date);
      }
    } else if (_selectedPeriod == 'Custom') {
      if (_customDates.isEmpty) return '';
      final date = _customDates[index];
      final today = DateTime.now();
      final yesterday = today.subtract(Duration(days: 1));
      
      if (date.year == today.year && date.month == today.month && date.day == today.day) {
        return 'Tdy';
      } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
        return 'Yst';
      } else {
        switch (_customPeriod) {
          case 'days':
            return DateFormat('d').format(date);
          case 'weeks':
            return 'W${DateFormat('w').format(date)}';
          case 'months':
            return DateFormat('MMM').format(date);
          case 'years':
            return DateFormat('yyyy').format(date);
          default:
            return DateFormat('d').format(date);
        }
      }
    }
    return '';
  }

  Future<void> _exportChartsToPDF() async {
    try {
      // Create a new PDF document
      final pdf = pw.Document();

      // Capture the donut chart
      final donutChartKey = GlobalKey();
      final donutChart = RepaintBoundary(
        key: donutChartKey,
        child: Container(
          width: 300,
          height: 300,
          color: Colors.transparent,
          child: AnimatedDonutChart(
            segments: _getMoodSegments(),
            strokeWidth: 48,
          ),
        ),
      );

      // Capture the line chart
      final lineChartKey = GlobalKey();
      final lineChart = RepaintBoundary(
        key: lineChartKey,
        child: Container(
          width: 300,
          height: 200,
          color: Colors.transparent,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 4,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final moods = ['😔', '😕', '😐', '😃', '😊'];
                      if (value % 1 == 0 && value >= 0 && value <= 4) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(moods[value.toInt()], style: TextStyle(color: Colors.white, fontSize: 18)),
                        );
                      }
                      return Container();
                    },
                    reservedSize: 32,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: _selectedPeriod == 'Past Week' ? 1 : 
                             _selectedPeriod == 'Past Month' ? 5 : 
                             _selectedPeriod == 'Custom' ? 
                               (_customPeriod == 'days' ? 1 :
                                _customPeriod == 'weeks' ? 1 :
                                _customPeriod == 'months' ? 1 : 1) :
                             _allTimePeriod == 'months' ? 1 : 1,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      if (_selectedPeriod == 'Past Week' && value >= 0 && value < 7) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(_getDayLabel(value.toInt()), style: TextStyle(color: Colors.white, fontSize: 14)),
                        );
                      } else if (_selectedPeriod == 'Past Month' && value >= 0 && value < 30) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(_getDayLabel(value.toInt()), style: TextStyle(color: Colors.white, fontSize: 14)),
                        );
                      } else if (_selectedPeriod == 'All Time' && value >= 0 && value < _allTimeDates.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(_getDayLabel(value.toInt()), style: TextStyle(color: Colors.white, fontSize: 14)),
                        );
                      } else if (_selectedPeriod == 'Custom' && value >= 0 && value < _customDates.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(_getDayLabel(value.toInt()), style: TextStyle(color: Colors.white, fontSize: 14)),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                horizontalInterval: 1,
                verticalInterval: _selectedPeriod == 'Past Week' ? 1 : 
                                 _selectedPeriod == 'Past Month' ? 5 : 
                                 _selectedPeriod == 'Custom' ? 
                                   (_customPeriod == 'days' ? 1 :
                                    _customPeriod == 'weeks' ? 1 :
                                    _customPeriod == 'months' ? 1 : 1) :
                                 _allTimePeriod == 'months' ? 1 : 1,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.white24,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: Colors.white24,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    for (int i = 0; i < (_selectedPeriod == 'Past Week' ? 7 : 
                                       _selectedPeriod == 'Past Month' ? 30 : 
                                       _selectedPeriod == 'Custom' ? _customDates.length :
                                       _allTimeDates.length); i++)
                      if (!(_selectedPeriod == 'Past Week' ? _weeklyMoodAverages[i] : 
                            _selectedPeriod == 'Past Month' ? _monthlyMoodAverages[i] : 
                            _selectedPeriod == 'Custom' ? _customMoodAverages[i] :
                            _allTimeMoodAverages[i]).isNaN)
                        FlSpot(i.toDouble(), _selectedPeriod == 'Past Week' ? _weeklyMoodAverages[i] : 
                                            _selectedPeriod == 'Past Month' ? _monthlyMoodAverages[i] : 
                                            _selectedPeriod == 'Custom' ? _customMoodAverages[i] :
                                            _allTimeMoodAverages[i])
                  ],
                  isCurved: true,
                  color: Colors.amberAccent,
                  barWidth: 4,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              lineTouchData: LineTouchData(
                enabled: false,
              ),
            ),
          ),
        ),
      );

      // Show loading indicator
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Preparing charts for export...'),
          duration: Duration(seconds: 2),
        ),
      );

      // Add the charts to the widget tree temporarily
      final overlay = Overlay.of(context);
      final donutEntry = OverlayEntry(
        builder: (context) => Positioned(
          left: -9999, // Position off-screen
          child: donutChart,
        ),
      );
      final lineEntry = OverlayEntry(
        builder: (context) => Positioned(
          left: -9999, // Position off-screen
          child: lineChart,
        ),
      );

      overlay.insert(donutEntry);
      overlay.insert(lineEntry);

      // Wait for the charts to be rendered
      await Future.delayed(Duration(milliseconds: 500));

      // Capture the charts
      final donutImage = await _captureWidget(donutChartKey);
      final lineImage = await _captureWidget(lineChartKey);

      // Remove the temporary entries
      donutEntry.remove();
      lineEntry.remove();

      // Add a page to the PDF
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // App title
                pw.Center(
                  child: pw.Text(
                    'MoodFlow',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),

                // Mood Distribution Chart
                pw.Text(
                  'Mood Distribution',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                if (donutImage != null)
                  pw.Center(
                    child: pw.Image(
                      pw.MemoryImage(donutImage),
                      width: 300,
                      height: 300,
                    ),
                  ),
                pw.SizedBox(height: 20),

                // Mood Trend Chart
                pw.Text(
                  'Mood Trend',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                if (lineImage != null)
                  pw.Center(
                    child: pw.Image(
                      pw.MemoryImage(lineImage),
                      width: 300,
                      height: 200,
                    ),
                  ),
              ],
            );
          },
        ),
      );

      // Save the PDF to a temporary file
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/moodflow_charts.pdf');
      await file.writeAsBytes(await pdf.save());

      if (!mounted) return;

      // Share the PDF
      try {
        final result = await Share.shareXFiles(
          [XFile(file.path)],
          text: 'MoodFlow Charts Export',
        );

        if (result.status == ShareResultStatus.dismissed) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Export cancelled'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (shareError) {
        print('Error sharing file: $shareError');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing file: ${shareError.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    } catch (e) {
      print('Error exporting charts: $e');
      if (!mounted) return;
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error exporting charts: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  Future<Uint8List?> _captureWidget(GlobalKey key) async {
    try {
      final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error capturing widget: $e');
      return null;
    }
  }

  void _showMoodPicker(BuildContext context) {
    print('DEBUG: Showing mood picker');
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
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
                            print('DEBUG: Mood picker Done button pressed');
                            Navigator.of(context).pop();
                            // Trigger analysis when mood changes
                            print('DEBUG: Selected period is $_selectedPeriod, calling _analyzeMoodCorrelations after mood change');
                              _analyzeMoodCorrelations();
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
                          print('DEBUG: Mood picker selection changed to index: $index');
                          setState(() {
                            switch (index) {
                              case 0:
                                _selectedMood = 'Heavy 😔';
                                break;
                              case 1:
                                _selectedMood = 'Low 😕';
                                break;
                              case 2:
                                _selectedMood = 'Neutral 😐';
                                break;
                              case 3:
                                _selectedMood = 'Light 😃';
                                break;
                              case 4:
                                _selectedMood = 'Bright ☺️';
                                break;
                            }
                          });
                          print('DEBUG: Selected mood changed to: $_selectedMood');
                          // Trigger analysis immediately when mood changes
                          _analyzeMoodCorrelations();
                        },
                        children: [
                          Center(
                            child: Text(
                              'Heavy 😔',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Low 😕',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Neutral 😐',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Light 😃',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Bright ☺️',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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

  // Add method to analyze mood correlations
  Future<void> _analyzeMoodCorrelations() async {
    print('\nDEBUG: Starting _analyzeMoodCorrelations');
    print('DEBUG: _selectedPeriod = $_selectedPeriod');
    
    if (_selectedPeriod != "Past Week" && _selectedPeriod != "Past Month" && 
        _selectedPeriod != "All Time" && _selectedPeriod != "Custom") {
      print('DEBUG: Not a valid period, returning early');
      return;
    }

    print('\nDEBUG: ANALYZING MOOD CORRELATIONS');
    print('DEBUG: Selected mood: "$_selectedMood"');
    
    setState(() {
      _isLoadingCorrelations = true;
      _whatsHappeningCounts.clear();
      _locationCounts.clear();
      _contactCounts.clear();
      _rawLogs.clear();
      _positiveMoodActivities.clear();
      _topPositiveActivities.clear();
      _negativeMoodActivities.clear();
      _topNegativeActivities.clear();
    });

    try {
      final now = DateTime.now();
      DateTime startDate;
      
      // Set date range based on selected period
      switch (_selectedPeriod) {
        case 'Past Week':
          startDate = now.subtract(Duration(days: 7));
          break;
        case 'Past Month':
          startDate = now.subtract(Duration(days: 30));
          break;
        case 'All Time':
          startDate = DateTime(now.year - 10, now.month, now.day, 0, 0, 0);
          break;
        case 'Custom':
          if (_rangeStart != null && _rangeEnd != null) {
            startDate = DateTime(_rangeStart!.year, _rangeStart!.month, _rangeStart!.day, 0, 0, 0);
          } else {
            print('DEBUG: Custom range not set, using past week as fallback');
            startDate = now.subtract(Duration(days: 7));
          }
          break;
        default:
          startDate = now.subtract(Duration(days: 7));
      }
      
      print('DEBUG: Date range: ${startDate.toIso8601String()} to ${now.toIso8601String()}');

      final user = FirebaseAuth.instance.currentUser;
      if (user?.email == null) {
        print('DEBUG: No user email found');
        return;
      }
      print('DEBUG: Current user email: ${user?.email}');

      final logsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.email)
          .collection('logs')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(now))
          .get();

      print('DEBUG: Found ${logsSnapshot.docs.length} logs in date range');

      // Normalize the selected mood by removing emoji and extra spaces
      final normalizedSelectedMood = _selectedMood.split(' ')[0].trim();
      print('DEBUG: Normalized selected mood: "$normalizedSelectedMood"');

      for (var doc in logsSnapshot.docs) {
        final data = doc.data();
        print('DEBUG: Processing log ${doc.id}');
        print('DEBUG: Log data: $data');
        
        final mood = data['mood']?.toString() ?? '';
        print('DEBUG: Raw mood value: "$mood"');
        
        // Normalize the log mood by removing emoji and extra spaces
        final normalizedLogMood = mood.split(' ')[0].trim();
        print('DEBUG: Normalized log mood: "$normalizedLogMood"');

        // Always analyze positive and negative moods regardless of selected mood
        if (normalizedLogMood == 'Bright' || normalizedLogMood == 'Light') {
          print('DEBUG: Found positive mood: $normalizedLogMood');
          try {
            final whatsHappeningSnapshot = await doc.reference.collection('whats_happening').get();
            print('DEBUG: Found ${whatsHappeningSnapshot.docs.length} whats_happening entries for positive mood');
            
            for (var whatsHappeningDoc in whatsHappeningSnapshot.docs) {
              final whatsHappeningData = whatsHappeningDoc.data();
              print('DEBUG: Whats happening data: $whatsHappeningData');
              
              final toggledIcons = whatsHappeningData['toggledIcons'] as List<dynamic>?;
              if (toggledIcons != null) {
                for (var activity in toggledIcons) {
                  if (activity is String && activity.isNotEmpty) {
                    _positiveMoodActivities[activity] = (_positiveMoodActivities[activity] ?? 0) + 1;
                    print('DEBUG: Added positive mood activity: "$activity"');
                  }
                }
              }
            }
          } catch (e) {
            print('DEBUG: Error querying whats_happening subcollection for positive mood: $e');
          }
        }
        // Check for negative moods (Heavy or Low)
        else if (normalizedLogMood == 'Heavy' || normalizedLogMood == 'Low') {
          print('DEBUG: Found negative mood: $normalizedLogMood');
          try {
            final whatsHappeningSnapshot = await doc.reference.collection('whats_happening').get();
            print('DEBUG: Found ${whatsHappeningSnapshot.docs.length} whats_happening entries for negative mood');
            
            for (var whatsHappeningDoc in whatsHappeningSnapshot.docs) {
              final whatsHappeningData = whatsHappeningDoc.data();
              print('DEBUG: Whats happening data: $whatsHappeningData');
              
              final toggledIcons = whatsHappeningData['toggledIcons'] as List<dynamic>?;
              if (toggledIcons != null) {
                for (var activity in toggledIcons) {
                  if (activity is String && activity.isNotEmpty) {
                    _negativeMoodActivities[activity] = (_negativeMoodActivities[activity] ?? 0) + 1;
                    print('DEBUG: Added negative mood activity: "$activity"');
                  }
                }
              }
            }
          } catch (e) {
            print('DEBUG: Error querying whats_happening subcollection for negative mood: $e');
          }
        }

        // Only analyze selected mood for the "Often Together" section
        if (normalizedLogMood == normalizedSelectedMood) {
          print('DEBUG: Mood matches selected mood');
          _rawLogs.add({
            'id': doc.id,
            'data': data,
          });

          try {
            final whatsHappeningSnapshot = await doc.reference.collection('whats_happening').get();
            print('DEBUG: Found ${whatsHappeningSnapshot.docs.length} whats_happening entries');
            
            for (var whatsHappeningDoc in whatsHappeningSnapshot.docs) {
              final whatsHappeningData = whatsHappeningDoc.data();
              print('DEBUG: Whats happening data: $whatsHappeningData');
              
              final toggledIcons = whatsHappeningData['toggledIcons'] as List<dynamic>?;
              if (toggledIcons != null) {
                for (var activity in toggledIcons) {
                  if (activity is String && activity.isNotEmpty) {
                    _whatsHappeningCounts[activity] = (_whatsHappeningCounts[activity] ?? 0) + 1;
                    print('DEBUG: Added whats_happening: "$activity"');
                  }
                }
              }
            }
          } catch (e) {
            print('DEBUG: Error querying whats_happening subcollection: $e');
          }
        }
      }

      // Sort and get top 3 positive activities
      _topPositiveActivities = _positiveMoodActivities.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      if (_topPositiveActivities.length > 3) {
        _topPositiveActivities = _topPositiveActivities.sublist(0, 3);
      }

      // Sort and get top 3 negative activities
      _topNegativeActivities = _negativeMoodActivities.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      if (_topNegativeActivities.length > 3) {
        _topNegativeActivities = _topNegativeActivities.sublist(0, 3);
      }

      print('DEBUG: Top positive activities: $_topPositiveActivities');
      print('DEBUG: Top negative activities: $_topNegativeActivities');

    } catch (e) {
      print('DEBUG: Error in _analyzeMoodCorrelations: $e');
    } finally {
      setState(() {
        _isLoadingCorrelations = false;
      });
    }
  }

  // Add new method to build the improve mood overlay
  Widget _buildImproveMoodOverlay() {
    String periodText = _selectedPeriod.toLowerCase();
    if (_selectedPeriod == 'Custom' && _rangeStart != null && _rangeEnd != null) {
      periodText = '${DateFormat('dd/MM/yyyy').format(_rangeStart!)} - ${DateFormat('dd/MM/yyyy').format(_rangeEnd!)}';
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 13.5),
          child: SvgPicture.asset(
            'assets/images/improve_your_mood.svg',
            width: 352,
            height: 75,
          ),
        ),
        Positioned(
          top: 10,
          child: Text(
            "Top activities that improve your mood",
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        if (_isLoadingCorrelations)
          Center(
            child: CupertinoActivityIndicator(
              color: Colors.white,
              radius: 12,
            ),
          )
        else if (_topPositiveActivities.isEmpty)
          Center(
            child: Text(
              'No positive mood activities found in the $periodText',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          )
        else
          Positioned(
            top: 35,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _topPositiveActivities.map((entry) {
                String iconPath = 'assets/images/${entry.key.toLowerCase()}.svg';
                if (entry.key == 'Music') {
                  iconPath = 'assets/images/music_log.svg';
                }
                return Container(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        iconPath,
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        entry.key,
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  // Add new method to build the negative mood overlay
  Widget _buildNegativeMoodOverlay() {
    String periodText = _selectedPeriod.toLowerCase();
    if (_selectedPeriod == 'Custom' && _rangeStart != null && _rangeEnd != null) {
      periodText = '${DateFormat('dd/MM/yyyy').format(_rangeStart!)} - ${DateFormat('dd/MM/yyyy').format(_rangeEnd!)}';
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 13.5),
          child: SvgPicture.asset(
            'assets/images/improve_your_mood.svg',
            width: 352,
            height: 75,
          ),
        ),
        Positioned(
          top: 10,
          child: Text(
            "Top activities that upset your mood",
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        if (_isLoadingCorrelations)
          Center(
            child: CupertinoActivityIndicator(
              color: Colors.white,
              radius: 12,
            ),
          )
        else if (_topNegativeActivities.isEmpty)
          Center(
            child: Text(
              'No negative mood activities found in the $periodText',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          )
        else
          Positioned(
            top: 35,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _topNegativeActivities.map((entry) {
                String iconPath = 'assets/images/${entry.key.toLowerCase()}.svg';
                if (entry.key == 'Music') {
                  iconPath = 'assets/images/music_log.svg';
                }
                return Container(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        iconPath,
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        entry.key,
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  // Add method to get contact avatar
  Future<Uint8List?> _getContactAvatar(String contactName) async {
    try {
      // Request contacts permission
      final status = await Permission.contacts.request();
      if (status.isGranted) {
        // Get all contacts
        final contacts = await ContactsService.getContacts();
        // Find the contact by name
        final contact = contacts.firstWhere(
          (contact) => contact.displayName == contactName,
          orElse: () => Contact(),
        );
        // Return the avatar if it exists
        return contact.avatar;
      }
    } catch (e) {
      print('Error getting contact avatar: $e');
    }
    return null;
  }

  // Add method to request contacts permission
  Future<bool> _requestContactsPermission() async {
    final status = await Permission.contacts.request();
    if (status.isGranted) {
      return true;
    }
    
    if (status.isPermanentlyDenied) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Contacts Permission Required'),
            content: const Text('Please enable contacts access in your device settings to see contact photos.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.pop(context);
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      }
    } else {
      if (mounted) {
        final completer = Completer<bool>();
        await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Contacts Permission Required'),
            content: const Text('Please allow contacts access to see contact photos.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  completer.complete(false);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final newStatus = await Permission.contacts.request();
                  completer.complete(newStatus.isGranted);
                },
                child: const Text('Allow'),
              ),
            ],
          ),
        );
        return completer.future;
      }
    }
    return false;
  }

  // Add method to get contact by phone number
  Future<Contact?> _getContactByPhoneNumber(String phoneNumber) async {
    try {
      print('\nDEBUG: ===== CONTACT SEARCH START =====');
      print('DEBUG: Searching for contact with phone number: $phoneNumber');
      
      // Get all contacts
      final contacts = await ContactsService.getContacts();
      print('DEBUG: Found ${contacts.length} total contacts in phone');
      
      // Find the contact by phone number
      for (var contact in contacts) {
        print('\nDEBUG: Checking contact: ${contact.displayName}');
        if (contact.phones != null) {
          print('DEBUG: Contact has ${contact.phones!.length} phone numbers:');
          for (var phone in contact.phones!) {
            print('DEBUG: - Phone: ${phone.value}');
            // Normalize phone numbers for comparison
            String normalizedPhone = phone.value!.replaceAll(RegExp(r'[^\d+]'), '');
            String normalizedSearch = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
            print('DEBUG: - Normalized phone: $normalizedPhone');
            print('DEBUG: - Normalized search: $normalizedSearch');
            
            if (normalizedPhone.contains(normalizedSearch) || normalizedSearch.contains(normalizedPhone)) {
              print('DEBUG: ✓ Found matching contact!');
              print('DEBUG: Contact details:');
              print('DEBUG: - Name: ${contact.displayName}');
              print('DEBUG: - Has avatar: ${contact.avatar != null && contact.avatar!.isNotEmpty}');
              print('DEBUG: - Email: ${contact.emails?.map((e) => e.value).join(", ")}');
              print('DEBUG: - Company: ${contact.company}');
              print('DEBUG: ===== CONTACT SEARCH END =====\n');
              return contact;
            }
          }
        } else {
          print('DEBUG: Contact has no phone numbers');
        }
      }
      print('DEBUG: No matching contact found');
      print('DEBUG: ===== CONTACT SEARCH END =====\n');
    } catch (error) {
      print('DEBUG: Error getting contact by phone number: $error');
      print('DEBUG: ===== CONTACT SEARCH END WITH ERROR =====\n');
    }
    return null;
  }

  // Add method to show correlation overlay
  Widget _buildCorrelationOverlay() {
    print('\nDEBUG: ===== BUILDING CORRELATION OVERLAY =====');
    print('DEBUG: Selected mood: "$_selectedMood"');
    print('DEBUG: Selected period: "$_selectedPeriod"');
    print('DEBUG: Raw logs count: ${_rawLogs.length}');

    // Group items by category
    List<MapEntry<String, int>> whatsHappeningItems = _whatsHappeningCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    print('DEBUG: Whats happening items: ${whatsHappeningItems.length}');

    return Stack(
      alignment: Alignment.center,
      children: [
        // Background
        Padding(
          padding: EdgeInsets.only(left: 13.5),
          child: SvgPicture.asset(
            'assets/images/often_together.svg',
            width: 352,
            height: 302,
          ),
        ),
        // Title
        Positioned(
          top: 12,
          child: Text(
            "Often Together",
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        // Mood Selector
        Positioned(
          top: 45,
          child: GestureDetector(
            onTap: () {
              print('DEBUG: Mood selector tapped');
              _showMoodPicker(context);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/mood_selector.svg',
                  width: 121,
                  height: 29,
                ),
                Positioned(
                  left: _selectedMood == 'Heavy 😔' ? 19 :
                        _selectedMood == 'Low 😕' ? 33 :
                        _selectedMood == 'Neutral 😐' ? 15 :
                        _selectedMood == 'Light 😃' ? 29 :
                        19, // default for Bright
                  child: Text(
                    _selectedMood,
                    style: GoogleFonts.roboto(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  left: 97,
                  top: 9,
                  child: SvgPicture.asset(
                    'assets/images/right_chevron_stat.svg',
                    width: 7.95,
                    height: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Content Area
        Positioned(
          top: 80,
          left: 20,
          right: 20,
          child: Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isLoadingCorrelations) ...[
                  Center(
                    child: CupertinoActivityIndicator(
                      color: Colors.white,
                      radius: 12,
                    ),
                  ),
                ] else if (_rawLogs.isEmpty) ...[
                  Center(
                    child: Text(
                      'No logs found for this mood in the ${_selectedPeriod.toLowerCase()}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ] else if (whatsHappeningItems.isEmpty) ...[
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Found ${_rawLogs.length} logs with this mood',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No activities recorded with these moods',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Try adding activities when logging your mood',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Container(
                    width: 325,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 0,
                      runSpacing: 20,
                      children: [
                        // Activities
                        ...whatsHappeningItems.map((entry) {
                          String iconPath = 'assets/images/${entry.key.toLowerCase()}.svg';
                          if (entry.key == 'Music') {
                            iconPath = 'assets/images/music_log.svg';
                          }
                          return SizedBox(
                            width: 65,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SvgPicture.asset(
                                iconPath,
                                width: 43,
                                height: 42,
                              ),
                              Positioned(
                                right: -2,
                                top: -2,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      entry.value.toString(),
                                      style: GoogleFonts.roboto(
                                        color: Color(0xFF646464),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  entry.key,
                                      style: GoogleFonts.roboto(
                                    color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
