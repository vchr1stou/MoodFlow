import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/app_bar.dart';

class ProfileGentleRemindersScreen extends StatefulWidget {
  const ProfileGentleRemindersScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return ProfileGentleRemindersScreen();
  }

  @override
  State<ProfileGentleRemindersScreen> createState() => _ProfileGentleRemindersScreenState();
}

class _ProfileGentleRemindersScreenState extends State<ProfileGentleRemindersScreen> {
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
                      if (userProvider.quoteReminderTime != null)
                        _ReminderRow(
                          time: _formatTime(userProvider.quoteReminderTime),
                          description: null,
                          onEdit: () {},
                          onDelete: () {},
                        ),
                    ],
                    enabledReminders: [userProvider.quoteReminderEnabled ?? false],
                  ),
                  const SizedBox(height: 18),
                  // Streak Reminder Section
                  _ReminderSection(
                    title: 'Streak Reminder',
                    enabled: userProvider.dailyStreakEnabled,
                    onToggle: (val) {
                      setState(() {
                        userProvider.toggleDailyStreak(val);
                      });
                    },
                    children: [
                      _ReminderRow(
                          time: _formatTime(userProvider.dailyStreakTime),
                          description: null,
                          onEdit: () {},
                          onDelete: () {},
                        ),
                    ],
                    enabledReminders: [userProvider.dailyStreakEnabled],
                  ),
                  const SizedBox(height: 32),
                  // Add new reminder button
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 220,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Add a new Reminder',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
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
    if (!enabled || count == 0) return 'assets/images/no_reminder.svg';
    if (count == 1) return 'assets/images/one_reminder.svg';
    if (count == 2) return 'assets/images/two_reminder.svg';
    if (count == 3) return 'assets/images/three_reminder.svg';
    if (count == 4) return 'assets/images/four_reminder.svg';
    return 'assets/images/four_reminder.svg'; // fallback
  }

  @override
  Widget build(BuildContext context) {
    final int remindersCount = enabled ? children.length : 0;
    final String sectionBg = _getSectionBackground(remindersCount, enabled);
    const double sectionWidth = 340.0;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SvgPicture.asset(
          sectionBg,
          width: sectionWidth,
          fit: BoxFit.fill,
        ),
        SizedBox(
          width: sectionWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Toggle header with gentle_reminders.svg background
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/gentle_reminders.svg',
                      width: MediaQuery.of(context).size.width - 20,
                      height: 54,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                          CupertinoSwitch(
                            value: enabled,
                            onChanged: onToggle,
                            activeColor: CupertinoColors.systemGreen,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Only show reminder rows if enabled
                if (enabled) 
                const SizedBox(height: 11),
                if(enabled)  ...children.map((child) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5.0),
                    child: child,
                  )),
                
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ReminderRow extends StatelessWidget {
  final String time;
  final String? description;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ReminderRow({
    required this.time,
    this.description,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/gentle_reminders.svg',
          width: MediaQuery.of(context).size.width - 64,
          height: 54,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Time and description in a column
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  if (description != null && description!.isNotEmpty)
                    Text(
                      description!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        fontFamily: 'Roboto',
                      ),
                    ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: onDelete,
                child: SvgPicture.asset(
                  'assets/images/trash.svg',
                  width: 22,
                  height: 22,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onEdit,
                child: SvgPicture.asset(
                  'assets/images/edit.svg',
                  width: 22,
                  height: 22,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
