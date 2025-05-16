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

  Future<void> _selectStreakTime(BuildContext context) async {
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
                          userProvider.dailyStreakTime.hour,
                          userProvider.dailyStreakTime.minute,
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
      await userProvider.updateStreakReminderTime(selectedTime!);
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
                      for (int i = 0; i < userProvider.dailyCheckInTimes.length; i++) 
                        if (userProvider.dailyCheckInEnabled?[i] == true)
                          _ReminderRow(
                            time: _formatTime(userProvider.dailyCheckInTimes[i]),
                            description: userProvider.dailyCheckInDescriptions?[i] ?? '',
                            onEdit: () {},
                            onDelete: () {},
                            onAdd: () {},
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
                          time: _formatTime(userProvider.quoteReminderTime ?? const TimeOfDay(hour: 9, minute: 0)),
                          description: null,
                          onEdit: () {},
                          onDelete: () {},
                          onAdd: () {},
                          isQuoteOfDay: true,
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (title == 'Daily Check - in')
                    SvgPicture.asset(
                      'assets/images/times_daily_checkin.svg',
                      width: 340.h,
                      height: 200.h,
                    )
                  else if (title == 'Quote of the Day')
                    SvgPicture.asset(
                      'assets/images/daily_toggle.svg',
                    ),
                  ...children.map((child) => child),
                ],
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

  const _ReminderRow({
    required this.time,
    this.description,
    required this.onEdit,
    required this.onDelete,
    this.isAddingReminder = false,
    required this.onAdd,
    this.isQuoteOfDay = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isQuoteOfDay) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 20.h,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: onAdd,
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
            ),
          ),
          if (isAddingReminder)
            Positioned(
              right: 18.h,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: onAdd,
                  child: SvgPicture.asset(
                    'assets/images/plus_gr.svg',
                  ),
                ),
              ),
            )
          else
            Positioned(
              right: 18.h,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: onDelete,
                      child: SvgPicture.asset(
                        'assets/images/trash.svg',
                      ),
                    ),
                    SizedBox(width: 7.h),
                    GestureDetector(
                      onTap: onEdit,
                      child: SvgPicture.asset(
                        'assets/images/edit.svg',
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          left: 20.h,
          top: 16.h,
          child: GestureDetector(
            onTap: onAdd,
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
        ),
        if (isAddingReminder)
          Positioned(
            right: 20.h,
            top: 20.h,
            child: GestureDetector(
              onTap: onAdd,
              child: SvgPicture.asset(
                'assets/images/plus_gr.svg',
              ),
            ),
          )
        else
          Positioned(
            right: 20.h,
            top: 16.h,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: onDelete,
                  child: SvgPicture.asset(
                    'assets/images/trash.svg',
                  ),
                ),
                SizedBox(width: 7.h),
                GestureDetector(
                  onTap: onEdit,
                  child: SvgPicture.asset(
                    'assets/images/edit.svg',
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
