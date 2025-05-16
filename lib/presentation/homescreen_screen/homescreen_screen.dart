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
import 'package:shared_preferences/shared_preferences.dart';

import 'models/homescreen_model.dart';
import 'provider/homescreen_provider.dart';
import '../../providers/user_provider.dart';
import 'package:provider/provider.dart';

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

class HomescreenScreenState extends State<HomescreenScreen> with AutomaticKeepAliveClientMixin {
  final UserService _userService = UserService();
  Map<String, Map<String, int>> _moodData = {};
  bool _isLoading = true;
  int _currentStreak = 0;
  String? _cachedUserName;
  late final Widget _littleLiftsScreen;
  StreamSubscription<DocumentSnapshot>? _userStreamSubscription;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Preload LittleLiftsScreen
    _littleLiftsScreen = LittleLiftsScreen.builder(context);
    
    // Initialize data loading
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Load cached data first
    await Future.wait([
      _loadCachedStreak(),
      _loadCachedUserName(),
    ]);

    // Then load fresh data
    await Future.wait([
      _loadMoodData(),
      _loadUserData(),
    ]);
  }

  @override
  void dispose() {
    _userStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail != null) {
      await userProvider.fetchUserData(userEmail);
      
      // Set up stream subscription
      _userStreamSubscription?.cancel();
      _userStreamSubscription = _userService.getCurrentUserStream().listen((snapshot) {
        if (snapshot.exists) {
          final userData = snapshot.data() as Map<String, dynamic>;
          final userName = (userData['name'] as String?)?.split(' ')[0] ?? 'User';
          if (_cachedUserName != userName) {
            _saveUserName(userName);
          }
        }
      });
    }
  }

  Future<void> _loadMoodData() async {
    if (!mounted) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      
      if (user?.email == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      final now = DateTime.now();
      final dates = List.generate(7, (index) => now.subtract(Duration(days: index)));

      // Initialize mood data structure
      final newMoodData = <String, Map<String, int>>{};
      for (var date in dates) {
        final dateStr = DateFormat('dd_MM_yyyy').format(date);
        newMoodData[dateStr] = {
          'Heavy': 0,
          'Low': 0,
          'Neutral': 0,
          'Light': 0,
          'Bright': 0,
        };
      }

      final logsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.email)
          .collection('logs');

      final querySnapshot = await logsRef.get();

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final timestamp = data['timestamp'] as Timestamp?;
        if (timestamp == null) continue;

        final logDate = timestamp.toDate();
        final dateStr = DateFormat('dd_MM_yyyy').format(logDate);
        
        if (!newMoodData.containsKey(dateStr)) continue;

        final mood = data['mood'] as String?;
        if (mood == null) continue;

        final moodName = mood.split(' ')[0];
        if (newMoodData[dateStr]!.containsKey(moodName)) {
          newMoodData[dateStr]![moodName] = (newMoodData[dateStr]![moodName] ?? 0) + 1;
        }
      }

      if (mounted) {
        setState(() {
          _moodData = newMoodData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadCachedStreak() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentStreak = prefs.getInt('current_streak') ?? 0;
    });
    // After loading cached value, calculate actual streak
    _calculateCurrentStreak();
  }

  Future<void> _calculateCurrentStreak() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user?.email == null) return;

      final logsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.email)
          .collection('logs');
          
      final QuerySnapshot querySnapshot = await logsRef.get();
      
      if (querySnapshot.docs.isEmpty) {
        await _saveStreak(0);
        return;
      }
      
      Map<String, bool> daysWithLogs = {};
      for (var doc in querySnapshot.docs) {
        final docId = doc.id;
        
        if (docId.contains('_')) {
          final parts = docId.split('_');
          if (parts.length >= 3) {
            try {
              final day = int.parse(parts[0]);
              final month = int.parse(parts[1]);
              final year = int.parse(parts[2]);
              
              final dateKey = '$day/$month/$year';
              daysWithLogs[dateKey] = true;
            } catch (e) {
              // Skip invalid document IDs
            }
          }
        }
      }
      
      final now = DateTime.now();
      int streak = 0;
      bool broken = false;
      
      for (int i = 0; i <= 100; i++) {
        final checkDate = now.subtract(Duration(days: i));
        final checkDay = checkDate.day;
        final checkMonth = checkDate.month;
        final checkYear = checkDate.year;
        
        final dateKey = '$checkDay/$checkMonth/$checkYear';
        final hasLog = daysWithLogs[dateKey] == true;
        
        if (hasLog) {
          streak++;
        } else {
          if (i > 0) {
            broken = true;
            break;
          }
        }
      }
      
      // Always update the streak value
      await _saveStreak(streak);
      
    } catch (e) {
      await _saveStreak(0);
    }
  }

  Future<void> _saveStreak(int streak) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_streak', streak);
    if (mounted) {
      setState(() {
        _currentStreak = streak;
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

  Widget _buildStatisticsCard() {
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
                    cacheColorFilter: true,
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
                            children: List.generate(7, (index) {
                              final day = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index];
                              final currentDayIndex = DateTime.now().weekday - 1;
                              return _buildStatBar(day, 1.0, isSelected: currentDayIndex == index);
                            }),
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

  Widget _buildStatBar(String day, double height, {bool isSelected = false}) {
    final now = DateTime.now();
    final mondayOfThisWeek = now.subtract(Duration(days: now.weekday - 1));
    final dayOffset = {'Mon': 0, 'Tue': 1, 'Wed': 2, 'Thu': 3, 'Fri': 4, 'Sat': 5, 'Sun': 6}[day] ?? 0;
    final date = mondayOfThisWeek.add(Duration(days: dayOffset));
    final dateStr = DateFormat('dd_MM_yyyy').format(date);
    final isFutureDate = date.isAfter(now);

    // Get mood data for this date if available
    final moods = _moodData[dateStr] ?? {
      'Heavy': 0,
      'Low': 0,
      'Neutral': 0,
      'Light': 0,
      'Bright': 0,
    };
    
    final total = moods.values.fold<int>(0, (sum, count) => sum + count);
    
    // Use a consistent bar height for all days
    const double barHeight = 81.0;

    // Find which moods are present (non-zero)
    final moodOrder = ['Bright', 'Light', 'Neutral', 'Low', 'Heavy'];
    final presentMoods = moodOrder.where((m) => moods[m]! > 0).toList();

    return RepaintBoundary(
      child: Column(
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
                  ...(() {
                    List<Widget> segments = [];
                    double cumulativeHeight = 0;
                    
                    // Process moods from bottom to top
                    for (String mood in moodOrder) {
                      if (moods[mood]! > 0) {
                        final segmentHeight = barHeight * (moods[mood]! / total);
                        
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
                                  if (presentMoods.length == 1) {
                                    return BorderRadius.circular(15);
                                  }
                                  if (cumulativeHeight == 0) {
                                    return BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    );
                                  }
                                  if (mood == presentMoods.last) {
                                    return BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    );
                                  }
                                  return BorderRadius.zero;
                                }(),
                              ),
                            ),
                          ),
                        );
                        
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
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
            Text(
              _cachedUserName ?? 'User',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
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
                      child: Consumer<UserProvider>(
                        builder: (context, userProvider, child) {
                          if (userProvider.profilePicFile != null) {
                            return ClipOval(
                              child: Image.file(
                                userProvider.profilePicFile!,
                                width: 37,
                                height: 37,
                                fit: BoxFit.cover,
                              ),
                            );
                          }
                          return Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: SvgPicture.asset(
                              'assets/images/person.crop.circle.fill.svg',
                              width: 37,
                              height: 37,
                            ),
                          );
                        },
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
          // Swiped right - use preloaded screen
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) => _littleLiftsScreen,
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
                  Positioned(
                    left: -20,
                    top: -10,
                    bottom: -10,
                    width: 200,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                    ),
                  ),

                  // Right side - Little Lifts text (navigates to Little Lifts screen)
                  Positioned(
                    right: -20,
                    top: -10,
                    bottom: -10,
                    width: 300,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (context, animation, secondaryAnimation) => _littleLiftsScreen,
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

  Future<void> _loadCachedUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _cachedUserName = prefs.getString('user_name');
    });
  }

  Future<void> _saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    setState(() {
      _cachedUserName = name;
    });
  }
}

