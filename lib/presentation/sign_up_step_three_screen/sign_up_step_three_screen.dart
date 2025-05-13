import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/sign_up_step_three_model.dart';
import 'provider/sign_up_step_three_provider.dart';
import '../../providers/user_provider.dart';

class SignUpStepThreeScreen extends StatefulWidget {
  const SignUpStepThreeScreen({Key? key}) : super(key: key);

  @override
  SignUpStepThreeScreenState createState() => SignUpStepThreeScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpStepThreeProvider(),
      child: SignUpStepThreeScreen(),
    );
  }
}

class SignUpStepThreeScreenState extends State<SignUpStepThreeScreen> {
  List<Contact> selectedContacts = [];

  @override
  void initState() {
    super.initState();
    _requestContactPermission();
  }

  Future<void> _requestContactPermission() async {
    final status = await Permission.contacts.request();
    if (status.isDenied) {
      // Handle the case where the user denied the permission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contact permission is required to add trusted contacts')),
      );
    }
  }

  Future<void> _pickContact() async {
    try {
      final Iterable<Contact> contacts = await ContactsService.getContacts();
      if (contacts.isNotEmpty) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Color(0xFFBCBCBC).withOpacity(0.04),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFBCBCBC).withOpacity(0.04),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 12.h),
                      Container(
                        width: 40.h,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(2.h),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        "Select a Contact",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ...contacts.map((contact) => _buildContactOption(contact)),
                              SizedBox(height: 24.h),
                            ],
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
    } catch (e) {
      print('Error picking contact: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking contact')),
      );
    }
  }

  Widget _buildContactOption(Contact contact) {
    return GestureDetector(
      onTap: () {
        if (!selectedContacts.any((c) => c.displayName == contact.displayName)) {
          setState(() {
            selectedContacts.add(contact);
          });
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('This contact is already added')),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.h),
        child: Row(
          children: [
            if (contact.avatar != null)
              CircleAvatar(
                radius: 20.h,
                backgroundImage: MemoryImage(contact.avatar!),
              )
            else
              CircleAvatar(
                radius: 20.h,
                child: Text(
                  contact.displayName?.substring(0, 1).toUpperCase() ?? '?',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            SizedBox(width: 16.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.displayName ?? 'Unknown',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),
                  if (contact.phones?.isNotEmpty == true)
                    Text(
                      contact.phones!.first.value ?? '',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF).withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto',
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

  Widget _buildContactWrapper(Contact contact, int index) {
    return Positioned(
      top: 20.h + (index * 70.h),
      child: Dismissible(
        key: Key(contact.displayName ?? 'contact_$index'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20.h),
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 24.h,
          ),
        ),
        onDismissed: (direction) {
          setState(() {
            selectedContacts.removeAt(index);
          });
        },
        child: GestureDetector(
          onTap: () async {
            try {
              final Iterable<Contact> contacts = await ContactsService.getContacts();
              if (contacts.isNotEmpty) {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) => Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: BoxDecoration(
                      color: Color(0xFFBCBCBC).withOpacity(0.04),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFBCBCBC).withOpacity(0.04),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 12.h),
                              Container(
                                width: 40.h,
                                height: 4.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(2.h),
                                ),
                              ),
                              SizedBox(height: 24.h),
                              Text(
                                "Replace Contact",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              SizedBox(height: 24.h),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ...contacts.map((newContact) => GestureDetector(
                                        onTap: () {
                                          if (!selectedContacts.any((c) => c.displayName == newContact.displayName)) {
                                            setState(() {
                                              selectedContacts[index] = newContact;
                                            });
                                            Navigator.pop(context);
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('This contact is already added')),
                                            );
                                          }
                                        },
                                        child: _buildContactOption(newContact),
                                      )),
                                      SizedBox(height: 24.h),
                                    ],
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
            } catch (e) {
              print('Error picking contact: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error picking contact')),
              );
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/contact_wrapper.svg',
                    width: 314.h,
                    height: 64.h,
                  ),
                  Positioned(
                    left: 20.h,
                    child: CircleAvatar(
                      radius: 20.h,
                      backgroundImage: contact.avatar != null
                          ? MemoryImage(contact.avatar!)
                          : null,
                      child: contact.avatar == null
                          ? Text(
                              contact.displayName?.substring(0, 1).toUpperCase() ?? '?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    left: 70.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.displayName ?? 'Unknown',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        Text(
                          contact.phones?.isNotEmpty == true
                              ? contact.phones!.first.value ?? ''
                              : 'No phone number',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF).withOpacity(0.6),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: _buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: BoxDecoration(
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
            // Top blur box
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 200.h,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Color(0xFFBCBCBC).withOpacity(0.04),
                  ),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20.h, left: 24.h, right: 24.h, bottom: 100.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10.h),
                                Center(
                                  child: SvgPicture.asset(
                                    'assets/images/safety_net.svg',
                                    width: 153,
                                    height: 85,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Container(
                                  width: double.infinity,
                                  child: Center(
                                    child: Text(
                                      "Your Safety Net",
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'Roboto',
                                        letterSpacing: -1,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Center(
                                  child: Text(
                                    "We all have people who help us breathe a little easier",
                                    style: TextStyle(
                                      fontSize: 14.9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                      letterSpacing: -1,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Center(
                                  child: Text(
                                    "Save them here, for peace of mind just in case you ever need to lean on someone.",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                      letterSpacing: -1,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        selectedContacts.length >= 3 
                                            ? 'assets/images/sign_up_safety_net_empty_bigger.svg'
                                            : 'assets/images/sign_up_safety_net_empty.svg',
                                        width: 340.h,
                                        height: selectedContacts.length >= 3 ? 388.h : 223.h,
                                      ),
                                      ...selectedContacts.asMap().entries.map((entry) => _buildContactWrapper(entry.value, entry.key)),
                                      if (selectedContacts.isEmpty)
                                        Positioned(
                                          top: 48.h,
                                          child: Text(
                                            "Add a Trusted Contact",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      if (selectedContacts.isEmpty)
                                        Align(
                                          alignment: Alignment.center,
                                          child: GestureDetector(
                                            onTap: _pickContact,
                                            child: SvgPicture.asset(
                                              'assets/images/sign_up_safety_net_plus.svg',
                                              width: 58.88.h,
                                              height: 57.1.h,
                                            ),
                                          ),
                                        ),
                                      if (selectedContacts.isNotEmpty && selectedContacts.length < 5)
                                        Positioned(
                                          top: 20.h + (selectedContacts.length * 70.h) + (selectedContacts.length == 1 ? 10.h : 0) + (selectedContacts.length >= 2 ? 5.h : 0) + (selectedContacts.length >= 3 ? 20.h : 0) - (selectedContacts.length >= 4 ? 10.h : 0),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: GestureDetector(
                                              onTap: _pickContact,
                                              child: SvgPicture.asset(
                                                'assets/images/sign_up_safety_net_plus.svg',
                                                width: selectedContacts.length >= 4 ? 45.h : (selectedContacts.length >= 3 ? 55.h : (selectedContacts.length >= 2 ? 40.h : 50.h)),
                                                height: selectedContacts.length >= 4 ? 45.h : (selectedContacts.length >= 3 ? 55.h : (selectedContacts.length >= 2 ? 40.h : 50.h)),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 24.h,
                      bottom: MediaQuery.of(context).padding.bottom + 5.h,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          // Update sign up provider contact list 
                          final userProvider = context.read<UserProvider>();
                          userProvider.updateStepThreeData(selectedContacts);
                          // Navigate to the next screen
                          Navigator.pushNamed(context, AppRoutes.finalSetUpScreen);
                        },
                        child: Container(
                          width: 130.h,
                          height: 60.h,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/next.svg',
                                width: 109.h,
                                height: 48.h,
                              ),
                              Text(
                                "Next",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
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

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 40,
      leading: Align(
        alignment: Alignment.centerLeft,
        child: _buildBackButton(),
      ),
    );
  }

  Widget _buildBackButton() {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: EdgeInsets.only(left: 12.h),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              Positioned(
                child: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
