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
import 'package:fl_chart/fl_chart.dart';

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
                                                  SizedBox(height: 20),
                                                  if (_selectedPeriod == 'Past Week' || _selectedPeriod == 'Past Month' || 
                                                      _selectedPeriod == 'All Time' || _selectedPeriod == 'Custom')
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
                                                                      ),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
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
}
