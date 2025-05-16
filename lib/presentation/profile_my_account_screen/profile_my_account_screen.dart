import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/profile_my_account_model.dart';
import 'provider/profile_my_account_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/app_bar.dart';

import '../../providers/user_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileMyAccountScreen extends StatefulWidget {
  const ProfileMyAccountScreen({Key? key}) : super(key: key);

  @override
  ProfileMyAccountScreenState createState() => ProfileMyAccountScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileMyAccountProvider(),
      child: ProfileMyAccountScreen(),
    );
  }
}

class ProfileMyAccountScreenState extends State<ProfileMyAccountScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.profilePicFile != null) {
      // Show dialog with three options
      final action = await showCupertinoModalPopup<String>(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: Text('Profile Picture'),
          message: Text('What would you like to do with your profile picture?'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context, 'edit'),
              child: Text('Edit Picture'),
            ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context, 'delete'),
              child: Text('Delete Picture'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: Text('Cancel'),
          ),
        ),
      );

      switch (action) {
        case 'delete':
          await userProvider.deleteProfilePic();
          return;
        case 'edit':
          // Continue to image picker
          break;
        case 'cancel':
        default:
          return;
      }
    }

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      await userProvider.updateProfilePic(File(image.path));
    }
  }

  Future<void> _showEditDialog(String title, String currentValue, Function(String) onSave) async {
    final TextEditingController controller = TextEditingController(text: currentValue);
    bool isPasswordVisible = false;
    bool isPassword = title == 'Password';

    return showCupertinoDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => CupertinoAlertDialog(
          title: Text('Edit $title'),
          content: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: CupertinoTextField(
              controller: controller,
              obscureText: isPassword && !isPasswordVisible,
              placeholder: 'Enter new $title',
              suffix: isPassword ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  isPasswordVisible ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                  color: CupertinoColors.systemGrey,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ) : null,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPronounsPicker() async {
    final List<String> pronouns = ['He / Him', 'She / Her', 'They / Them'];
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentPronouns = userProvider.pronouns ?? '';

    showCupertinoModalPopup(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
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
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 250,
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
                        itemExtent: 32,
                        onSelectedItemChanged: (int index) {
                          userProvider.updatePronouns(pronouns[index]);
                        },
                        children: pronouns.map((String pronoun) {
                          return Center(
                            child: Text(
                              pronoun,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        }).toList(),
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
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

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
        child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                SizedBox(height: 32),
                // Main My Account Card
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: SvgPicture.asset(
                        'assets/images/my_account_page_widget.svg',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Avatar
                          GestureDetector(
                            onTap: () => _pickImage(context),
                            child: Consumer<UserProvider>(
                              builder: (context, userProvider, child) {
                                if (userProvider.profilePicFile != null) {
                                  return ClipOval(
                                    child: Image.file(
                                      userProvider.profilePicFile!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }
                                return Padding(
                                  padding: EdgeInsets.only(top: 3),
                                  child: SvgPicture.asset(
                                    'assets/images/person.crop.circle.fill.svg',
                                    width: 80,
                                    height: 80,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Edit Button
                          GestureDetector(
                            onTap: () => _pickImage(context),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                'assets/images/edit_widget.svg',
                                width: 126,
                                height: 30,
                                fit: BoxFit.contain,
                              ),
                              const Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                          ),
                          const SizedBox(height: 32),
                          // Name Row
                          GestureDetector(
                            onTap: () => _showEditDialog(
                              'Name',
                              userProvider.name ?? '',
                              (newName) => userProvider.updateName(newName),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/top_my_account.svg',
                                  width: MediaQuery.of(context).size.width - 40,
                                  fit: BoxFit.fill,
                                  height: 54,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, right: 17.0),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Name',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        userProvider.name ?? 'User',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Icon(Icons.chevron_right, color: Colors.white, size: 20),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Pronouns Row
                          GestureDetector(
                            onTap: _showPronounsPicker,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/medium_my_account.svg',
                                  width: MediaQuery.of(context).size.width - 40,
                                  fit: BoxFit.fill,
                                  height: 54,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, right: 17.0),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Pronouns',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        userProvider.pronouns ?? '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Icon(Icons.chevron_right, color: Colors.white, size: 20),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Email Row
                          GestureDetector(
                            onTap: () => _showEditDialog(
                              'Email',
                              userProvider.email ?? '',
                              (newEmail) => userProvider.updateEmail(newEmail),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/medium_my_account.svg',
                                  width: MediaQuery.of(context).size.width - 40,
                                  fit: BoxFit.fill,
                                  height: 54,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, right: 17.0),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'E-mail',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        userProvider.email ?? '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Icon(Icons.chevron_right, color: Colors.white, size: 20),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Password Row
                          GestureDetector(
                            onTap: () => _showEditDialog(
                              'Password',
                              '',
                              (newPassword) => userProvider.updatePassword(newPassword),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/bottom_my_account.svg',
                                  width: MediaQuery.of(context).size.width - 40,
                                  fit: BoxFit.fill,
                                  height: 54,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, right: 17.0),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Password',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      Spacer(),
                                      const Text(
                                        '•••••••',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Icon(Icons.chevron_right, color: Colors.white, size: 20),
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
                SizedBox(height: 32),
                // Sign Out Button
                GestureDetector(
                  onTap: () {
                    userProvider.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                      context, 
                      AppRoutes.welcomeScreen,
                      (route) => false,
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                      'assets/images/sign_out.svg',
                      width: 190,
                      height: 44,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
          )
    );
  }

}
