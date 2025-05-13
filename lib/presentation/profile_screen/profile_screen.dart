import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'provider/profile_provider.dart';
import 'widgets/profile_one_item_widget.dart';

import '../../providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/app_bar.dart';
import 'package:moodflow/core/utils/size_utils.dart';
import 'dart:ui';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileProvider(),
      child: ProfileScreen(),
    );
  }
}
// ...existing imports...

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return Scaffold(
      extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: buildAppbar(context),
          body: Container(
            width: double.maxFinite,
            height: SizeUtils.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),

        child: Stack(
        children: [
          // Background blur overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: Color(0xFFBCBCBC).withOpacity(0.04),
              ),
            ),
          ),
          // Bottom SVG (settings background)
          Align(
            alignment: Alignment.bottomCenter,
            child: SvgPicture.asset(
              'assets/images/Settings_profile.svg',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            left: 18,
            top: 116,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 36, // Adjust width as needed
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  SvgPicture.asset(
                    'assets/images/profile_widget.svg',
                    width: MediaQuery.of(context).size.width - 36,
                    fit: BoxFit.fitWidth,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "My Account",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.chevron_right, color: Colors.white),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                provider.name ?? 'User',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                provider.email ?? '',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.emoji_emotions, size: 48, color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Main content with top SVG (profile card)
          SingleChildScrollView(
            child: Column(
              children: [
                // Settings list
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      children: [
                        _buildSettingRow(
                          icon: Icons.local_fire_department,
                          text: "Daily Streak",
                          trailing: Switch(
                            value: provider.dailyStreakEnabled,
                            onChanged: (bool value) => provider.toggleDailyStreak(value),
                            activeColor: Colors.green,
                          ),
                        ),
                        _buildSettingRow(
                          icon: Icons.music_note,
                          text: "Sound",
                          trailing: Switch(
                            value: provider.soundEnabled,
                            onChanged: (bool value) => provider.toggleSound(value),
                            activeColor: Colors.green,
                          ),
                        ),
                        _buildSettingRow(
                          icon: Icons.music_video,
                          text: "Music",
                          trailing: Switch(
                            value: provider.musicEnabled,
                            onChanged: (bool value) => provider.toggleMusic(value),
                            activeColor: Colors.green,
                          ),
                        ),
                        _buildSettingRow(
                          icon: Icons.vibration,
                          text: "Haptic Feedback",
                          trailing: Switch(
                            value: provider.hapticEnabled,
                            onChanged: (bool value) => provider.toggleHaptic(value),
                            activeColor: Colors.green,
                          ),
                        ),
                        _buildSettingRow(
                          icon: Icons.notifications_active,
                          text: "Gentle Reminders",
                          trailing: Icon(Icons.chevron_right, color: Colors.white),
                          onTap: () {
                            // Navigate to Gentle Reminders screen
                          },
                        ),
                        _buildSettingRow(
                          icon: Icons.lock,
                          text: "Set PIN",
                          trailing: Icon(Icons.chevron_right, color: Colors.white),
                          onTap: () {
                            // Navigate to Set PIN screen
                          },
                        ),
                        _buildSettingRow(
                          icon: Icons.music_note,
                          text: "Spotify Account",
                          trailing: Icon(Icons.chevron_right, color: Colors.white),
                          onTap: () {
                            // Navigate to Spotify Account screen
                          },
                        ),
                        _buildSettingRow(
                          icon: Icons.accessibility_new,
                          text: "Accessibility",
                          trailing: Icon(Icons.chevron_right, color: Colors.white),
                          onTap: () {
                            // Navigate to Accessibility screen
                          },
                        ),
                        _buildSettingRow(
                          icon: Icons.group,
                          text: "Your Safety Net",
                          trailing: Icon(Icons.chevron_right, color: Colors.white),
                          onTap: () {
                            // Navigate to Safety Net screen
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String text,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      tileColor: Colors.transparent,
      dense: true,
    );
  }
}