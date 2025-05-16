import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/app_bar.dart';
import '../../core/utils/size_utils.dart';

class ProfileGentleRemindersScreen extends StatefulWidget {
  const ProfileGentleRemindersScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return ProfileGentleRemindersScreen();
  }

  @override
  State<ProfileGentleRemindersScreen> createState() => _ProfileGentleRemindersScreenState();
}

class _ProfileGentleRemindersScreenState extends State<ProfileGentleRemindersScreen> {
  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  bool _isAddingStreakReminder = false;
  List<bool> _isAddingDailyReminders = [false, false, false, false];

  Future<void> _selectDailyTime(BuildContext context, int index) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    TimeOfDay selectedTime = userProvider.dailyCheckInTimes[index];
    TextEditingController titleController = TextEditingController(
      text: userProvider.dailyCheckInTitles[index] ?? "How are you feeling?"
    );
    
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 400,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Color(0xFFBCBCBC).withOpacity(0.04),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
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
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 250,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        initialDateTime: DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          userProvider.dailyCheckInTimes[index].hour,
                          userProvider.dailyCheckInTimes[index].minute,
                        ),
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newDateTime) {
                          selectedTime = TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CupertinoTextField(
                      controller: titleController,
                      placeholder: "Enter reminder title",
                      placeholderStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(12),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await userProvider.updateDailyCheckInTime(index, selectedTime);
    await userProvider.updateDailyCheckInTitle(index, titleController.text);
    setState(() {
      _isAddingDailyReminders[index] = false;
    });
  }

  Future<void> _selectQuoteTime(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    TimeOfDay? selectedTime;
    
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Color(0xFFBCBCBC).withOpacity(0.04),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
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
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 250,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        initialDateTime: DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          userProvider.quoteReminderTime?.hour ?? 9,
                          userProvider.quoteReminderTime?.minute ?? 0,
                        ),
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newDateTime) {
                          selectedTime = TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (selectedTime != null) {
      await userProvider.updateQuoteReminderTime(selectedTime!);
      setState(() {
        _isAddingStreakReminder = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: buildAppbar(context),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Top back button and bell icon
                  SvgPicture.asset(
                    'assets/images/bell.badge.fill 1.svg',
                    width: 62,
                    height: 62,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Gentle Reminders',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Daily Check-in Section
                  _ReminderSection(
                    title: 'Daily Check - in',
                    enabled: userProvider.dailyCheckInSectionEnabled ?? false,
                    onToggle: (val) {
                      setState(() {
                        userProvider.toggleCheckInReminder(val);
                      });
                    },
                    children: [
                      if (userProvider.dailyCheckInSectionEnabled ?? false)
                        SizedBox(
                          height: 242.h, // Height for 4 rows (60.h each) plus spacing
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0.h,
                                top: -12.h,
                                child: SizedBox(
                                  height: 60,
                                  width: 340.h,
                                  child: Row(
                                    children: [
                                      SizedBox(width: 18.h),
                                      Expanded(
                                        child: !_isAddingDailyReminders[0] ? Text(
                                          _formatTime(userProvider.dailyCheckInTimes[0]),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white.withOpacity(0.96),
                                            fontFamily: 'Roboto',
                                          ),
                                        ) : SizedBox(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (_isAddingDailyReminders[0])
                                Positioned(
                                  left: 18.h,
                                  top: 14.h,
                                  child: Text(
                                    "Add a Gentle Reminder",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.96),
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                              if (_isAddingDailyReminders[0])
                                Positioned(
                                  right: 30.h,
                                  top: 15.h,
                                  child: GestureDetector(
                                    onTap: () {
                                      userProvider.toggleDailyCheckIn(0, true);
                                      _selectDailyTime(context, 0);
                                    },
                                    child: SvgPicture.asset('assets/images/plus_gr.svg'),
                                  ),
                                ),
                              Positioned(
                                left: 18.h,
                                top: 25.h,
                                child: !_isAddingDailyReminders[0] ? Text(
                                  userProvider.dailyCheckInTitles[0] ?? "How are you feeling?",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.96),
                                    fontFamily: 'Roboto',
                                  ),
                                ) : SizedBox(),
                              ),
                              Positioned(
                                right: 25.h,
                                top: 14.h,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!_isAddingDailyReminders[0]) ...[
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isAddingDailyReminders[0] = true;
                                          });
                                        },
                                        child: SvgPicture.asset(
                                          'assets/images/trash.svg',
                                          width: 19.88.h,
                                          height: 24.12.h,
                                        ),
                                      ),
                                      SizedBox(width: 7.h),
                                      GestureDetector(
                                        onTap: () => _selectDailyTime(context, 0),
                                        child: SvgPicture.asset(
                                          'assets/images/edit.svg',
                                          width: 20.h,
                                          height: 18.h,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Positioned(
                                left: -1.h,
                                top: 35.h,
                                child: SizedBox(
                                  height: 60,
                                  width: 340.h,
                                  child: Row(
                                    children: [
                                      SizedBox(width: 18.h),
                                      Expanded(
                                        child: !_isAddingDailyReminders[1] ? Text(
                                          _formatTime(userProvider.dailyCheckInTimes[1]),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white.withOpacity(0.96),
                                            fontFamily: 'Roboto',
                                          ),
                                        ) : SizedBox(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (_isAddingDailyReminders[1])
                                Positioned(
                                  left: 18.h,
                                  top: 62.h,
                                  child: Text(
                                    "Add a Gentle Reminder",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.96),
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                              if (_isAddingDailyReminders[1])
                                Positioned(
                                  right: 30.h,
                                  top: 64.h,
                                  child: GestureDetector(
                                    onTap: () {
                                      userProvider.toggleDailyCheckIn(1, true);
                                      _selectDailyTime(context, 1);
                                    },
                                    child: SvgPicture.asset('assets/images/plus_gr.svg'),
                                  ),
                                ),
                              Positioned(
                                left: 18.h,
                                top: 71.h,
                                child: !_isAddingDailyReminders[1] ? Text(
                                  userProvider.dailyCheckInTitles[1] ?? "How are you feeling?",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.96),
                                    fontFamily: 'Roboto',
                                  ),
                                ) : SizedBox(),
                              ),
                              Positioned(
                                right: 25.h,
                                top: 60.h,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!_isAddingDailyReminders[1]) ...[
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isAddingDailyReminders[1] = true;
                                          });
                                        },
                                        child: SvgPicture.asset(
                                          'assets/images/trash.svg',
                                          width: 19.88.h,
                                          height: 24.12.h,
                                        ),
                                      ),
                                      SizedBox(width: 7.h),
                                      GestureDetector(
                                        onTap: () => _selectDailyTime(context, 1),
                                        child: SvgPicture.asset(
                                          'assets/images/edit.svg',
                                          width: 20.h,
                                          height: 18.h,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Positioned(
                                left: -1.h,
                                top: 85.h,
                                child: SizedBox(
                                  height: 60,
                                  width: 340.h,
                                  child: Row(
                                    children: [
                                      SizedBox(width: 18.h),
                                      Expanded(
                                        child: !_isAddingDailyReminders[2] ? Text(
                                          _formatTime(userProvider.dailyCheckInTimes[2]),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white.withOpacity(0.96),
                                            fontFamily: 'Roboto',
                                          ),
                                        ) : SizedBox(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (_isAddingDailyReminders[2])
                                Positioned(
                                  left: 18.h,
                                  top: 110.h,
                                  child: Text(
                                    "Add a Gentle Reminder",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.96),
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                              if (_isAddingDailyReminders[2])
                                Positioned(
                                  right: 30.h,
                                  top: 112.h,
                                  child: GestureDetector(
                                    onTap: () {
                                      userProvider.toggleDailyCheckIn(2, true);
                                      _selectDailyTime(context, 2);
                                    },
                                    child: SvgPicture.asset('assets/images/plus_gr.svg'),
                                  ),
                                ),
                              Positioned(
                                left: 18.h,
                                top: 122.h,
                                child: !_isAddingDailyReminders[2] ? Text(
                                  userProvider.dailyCheckInTitles[2] ?? "How are you feeling?",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.96),
                                    fontFamily: 'Roboto',
                                  ),
                                ) : SizedBox(),
                              ),
                              Positioned(
                                right: 25.h,
                                top: 110.h,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!_isAddingDailyReminders[2]) ...[
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isAddingDailyReminders[2] = true;
                                          });
                                        },
                                        child: SvgPicture.asset(
                                          'assets/images/trash.svg',
                                          width: 19.88.h,
                                          height: 24.12.h,
                                        ),
                                      ),
                                      SizedBox(width: 7.h),
                                      GestureDetector(
                                        onTap: () => _selectDailyTime(context, 2),
                                        child: SvgPicture.asset(
                                          'assets/images/edit.svg',
                                          width: 20.h,
                                          height: 18.h,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 0.h,
                                top: 133.h,
                                child: SizedBox(
                                  height: 60,
                                  width: 340.h,
                                  child: Row(
                                    children: [
                                      SizedBox(width: 18.h),
                                      Expanded(
                                        child: !_isAddingDailyReminders[3] ? Text(
                                          _formatTime(userProvider.dailyCheckInTimes[3]),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white.withOpacity(0.96),
                                            fontFamily: 'Roboto',
                                          ),
                                        ) : SizedBox(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (_isAddingDailyReminders[3])
                                Positioned(
                                  left: 18.h,
                                  top: 157.h,
                                  child: Text(
                                    "Add a Gentle Reminder",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.96),
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                              if (_isAddingDailyReminders[3])
                                Positioned(
                                  right: 30.h,
                                  top: 160.h,
                                  child: GestureDetector(
                                    onTap: () {
                                      userProvider.toggleDailyCheckIn(3, true);
                                      _selectDailyTime(context, 3);
                                    },
                                    child: SvgPicture.asset('assets/images/plus_gr.svg'),
                                  ),
                                ),
                              Positioned(
                                left: 19.h,
                                top: 168.h,
                                child: !_isAddingDailyReminders[3] ? Text(
                                  userProvider.dailyCheckInTitles[3] ?? "How are you feeling?",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.96),
                                    fontFamily: 'Roboto',
                                  ),
                                ) : SizedBox(),
                              ),
                              Positioned(
                                right: 25.h,
                                top: 160.h,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!_isAddingDailyReminders[3]) ...[
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isAddingDailyReminders[3] = true;
                                          });
                                        },
                                        child: SvgPicture.asset(
                                          'assets/images/trash.svg',
                                          width: 19.88.h,
                                          height: 24.12.h,
                                        ),
                                      ),
                                      SizedBox(width: 7.h),
                                      GestureDetector(
                                        onTap: () => _selectDailyTime(context, 3),
                                        child: SvgPicture.asset(
                                          'assets/images/edit.svg',
                                          width: 20.h,
                                          height: 18.h,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                          ),
                    ],
                    enabledReminders: userProvider.dailyCheckInEnabled ?? [],
                  ),
                  const SizedBox(height: 18),
                  // Quote of the Day Section
                  _ReminderSection(
                    title: 'Quote of the Day',
                    enabled: userProvider.quoteReminderEnabled ?? false,
                    onToggle: (val) {
                      setState(() {
                        userProvider.toggleQuoteReminder(val);
                      });
                    },
                    children: [
                      if (userProvider.quoteReminderEnabled ?? false)
                        _ReminderRow(
                          time: _isAddingStreakReminder
                            ? "Add a Gentle Reminder"
                            : _formatTime(userProvider.quoteReminderTime ?? const TimeOfDay(hour: 9, minute: 0)),
                          description: null,
                          onEdit: () => _selectQuoteTime(context),
                          onDelete: () {
                            setState(() {
                              _isAddingStreakReminder = true;
                            });
                          },
                          onAdd: () {
                            setState(() {
                              userProvider.toggleQuoteReminder(true);
                              _selectQuoteTime(context);
                            });
                          },
                          isAddingReminder: _isAddingStreakReminder,
                          isQuoteOfDay: true,
                          binPadding: EdgeInsets.only(top: 8.h, right: 8.h),
                          editPadding: EdgeInsets.only(top: 4.h, left: 8.h),
                        ),
                    ],
                    enabledReminders: [userProvider.quoteReminderEnabled ?? false],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReminderSection extends StatelessWidget {
  final String title;
  final bool enabled;
  final ValueChanged<bool> onToggle;
  final List<Widget> children;
  final List<bool> enabledReminders;

  const _ReminderSection({
    required this.title,
    required this.enabled,
    required this.onToggle,
    required this.children,
    required this.enabledReminders,
  });

  String _getSectionBackground(int count, bool enabled) {
    if (!enabled) return 'assets/images/daily_toggle_off.svg';
    if (title == 'Daily Check - in') return 'assets/images/daily_checkin.svg';
    if (title == 'Quote of the Day') return 'assets/images/quote_daily.svg';
    return 'assets/images/daily_toggle_off.svg'; // fallback
  }

  @override
  Widget build(BuildContext context) {
    final int remindersCount = enabled ? children.length : 0;
    final String sectionBg = _getSectionBackground(remindersCount, enabled);
    final double sectionWidth = 340.h;
    final double sectionHeight = enabled ? (title == 'Daily Check - in' ? 283.h : 155.h) : 79.h;

    return Container(
      width: sectionWidth,
      height: sectionHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            sectionBg,
            width: sectionWidth,
            height: sectionHeight,
          ),
          Positioned(
            top: 12.h,
            left: 0,
            right: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/daily_toggle.svg',
                ),
                Positioned(
                  left: 30.h,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                Positioned(
                  right: 30.h,
                  child: Transform.scale(
                    scale: 0.9,
                    child: CupertinoSwitch(
                      value: enabled,
                      onChanged: onToggle,
                      activeColor: CupertinoColors.systemGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (enabled)
            Positioned(
              top: 12.h + 55.h + 7.h,
              child: SizedBox(
                width: sectionWidth,
                height: title == 'Daily Check - in' ? 200.h : 80.h,
                child: Stack(
                  children: [
                    if (title == 'Daily Check - in')
                      Positioned(
                        left: 10.h,
                        top: 0,
                        child: SvgPicture.asset(
                          'assets/images/times_daily_checkin.svg',
                          width: 340.h,
                          height: 200.h,
                          fit: BoxFit.fill,
                        ),
                      )
                    else if (title == 'Quote of the Day')
                      Positioned(
                        left: 10.h,
                        top: 3.h,
                        child: SvgPicture.asset(
                          'assets/images/daily_toggle.svg',
                          width: 313.h,
                          height: 56.h,
                          fit: BoxFit.fill,
                        ),
                      ),
                    if (children.isNotEmpty)
                      Positioned(
                        left: 12.h,
                        top: 2.h,
                        right: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: children,
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReminderRow extends StatelessWidget {
  final String time;
  final String? description;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isAddingReminder;
  final VoidCallback onAdd;
  final bool isQuoteOfDay;
  final EdgeInsets? binPadding;
  final EdgeInsets? editPadding;

  const _ReminderRow({
    required this.time,
    this.description,
    required this.onEdit,
    required this.onDelete,
    this.isAddingReminder = false,
    required this.onAdd,
    this.isQuoteOfDay = false,
    this.binPadding,
    this.editPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAdd,
      child: SizedBox(
        height: 60,
        width: 340.h,
        child: Row(
          children: [
            SizedBox(width: 18.h),
            Expanded(
              child: Text(
              time,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.96),
                fontFamily: 'Roboto',
              ),
            ),
            ),
            if (isAddingReminder)
              Padding(
                padding: EdgeInsets.only(right: 20.h),
                child: SvgPicture.asset('assets/images/plus_gr.svg'),
              )
            else ...[
              GestureDetector(
                onTap: onDelete,
                child: SvgPicture.asset(
                  'assets/images/trash.svg',
                  width: 19.88.h,
                  height: 24.12.h,
                ),
              ),
              SizedBox(width: 7.h),
              GestureDetector(
                onTap: onEdit,
                child: SvgPicture.asset(
                  'assets/images/edit.svg',
                  width: 20.h,
                  height: 18.h,
                ),
              ),
              SizedBox(width: 10.h),
            ],
            SizedBox(width: 20.h),
          ],
        ),
      ),
    );
  }
}
