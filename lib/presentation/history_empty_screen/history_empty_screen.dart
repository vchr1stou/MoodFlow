import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/app_export.dart';
import '../log_input_screen/log_input_screen.dart';
import '../homescreen_screen/homescreen_screen.dart';

import 'models/history_empty_model.dart';
import 'provider/history_empty_provider.dart';

class HistoryEmptyScreen extends StatefulWidget {
  const HistoryEmptyScreen({Key? key}) : super(key: key);

  @override
  HistoryEmptyScreenState createState() => HistoryEmptyScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryEmptyProvider(),
      child: const HistoryEmptyScreen(),
    );
  }
}

class HistoryEmptyScreenState extends State<HistoryEmptyScreen> {
  final String mainText = 'Bright stories start on blank pages.';
  final String subText = 'When you\'re ready, press record on how you feel.';
  DateTime selectedDate = DateTime.now();
  bool hasLogs = false;
  bool isLoading = true;
  int logCount = 0;
  List<DateTime> logTimes = [];
  List<String> logMoods = [];
  List<String> toggledIcons = [];
  List<Map<String, dynamic>> logContacts = [];
  List<String> positiveFeelings = [];

  @override
  void initState() {
    super.initState();
    _checkForLogs();
  }

  Future<void> _requestContactPermission() async {
    final status = await Permission.contacts.request();
    if (status.isDenied) {
      print('Contact permission denied');
    }
  }

  Future<Contact?> _findContactByPhone(String phoneNumber) async {
    try {
      final contacts = await ContactsService.getContacts();
      for (var contact in contacts) {
        if (contact.phones != null) {
          for (var phone in contact.phones!) {
            // Remove any non-digit characters for comparison
            final cleanPhone = phone.value?.replaceAll(RegExp(r'[^\d+]'), '');
            final cleanSearchPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
            if (cleanPhone == cleanSearchPhone) {
              return contact;
            }
          }
        }
      }
    } catch (e) {
      print('Error finding contact: $e');
    }
    return null;
  }

  Future<void> _checkForLogs() async {
    setState(() {
      isLoading = true;
      logTimes = [];
      logMoods = [];
      toggledIcons = [];
      logContacts = [];
      positiveFeelings = [];
    });

    try {
      await _requestContactPermission();
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        setState(() {
          hasLogs = false;
          logCount = 0;
          logTimes = [];
          logMoods = [];
          toggledIcons = [];
          logContacts = [];
          positiveFeelings = [];
          isLoading = false;
        });
        return;
      }

      // Format the date as DD_MM_YYYY
      final dateStr = '${selectedDate.day.toString().padLeft(2, '0')}_${selectedDate.month.toString().padLeft(2, '0')}_${selectedDate.year}';
      
      // Get all logs for this date
      final logsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .collection('logs')
          .where(FieldPath.documentId, isGreaterThanOrEqualTo: dateStr)
          .where(FieldPath.documentId, isLessThan: dateStr + '_z')
          .get();

      print('Found ${logsSnapshot.docs.length} logs for date: $dateStr');

      // Extract timestamps, moods, and toggled icons from logs
      final times = logsSnapshot.docs.map((doc) {
        final data = doc.data();
        print('Log data: ${data}');
        final timestamp = data['createdAt'] as Timestamp?;
        return timestamp?.toDate() ?? DateTime.now();
      }).toList();

      final moods = logsSnapshot.docs.map((doc) {
        final data = doc.data();
        return data['mood'] as String? ?? 'N/A';
      }).toList();

      // Get icons from whats_happening subcollection
      List<List<String>> allIcons = [];
      List<List<Map<String, dynamic>>> allContacts = [];
      
      for (var doc in logsSnapshot.docs) {
        print('Processing log: ${doc.id}');
        
        // Get whats_happening data
        final whatsHappeningSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('logs')
            .doc(doc.id)
            .collection('whats_happening')
            .get();
        
        if (whatsHappeningSnapshot.docs.isNotEmpty) {
          final whatsHappeningData = whatsHappeningSnapshot.docs.first.data();
          
          if (whatsHappeningData.containsKey('toggledIcons')) {
            final iconsList = whatsHappeningData['toggledIcons'] as List<dynamic>?;
            if (iconsList != null && iconsList.isNotEmpty) {
              final firstThreeIcons = iconsList.take(3).map((icon) => icon.toString()).toList();
              allIcons.add(firstThreeIcons);
            } else {
              allIcons.add([]);
            }
          } else {
            allIcons.add([]);
          }
        } else {
          allIcons.add([]);
        }

        // Get contacts data
        final contactsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('logs')
            .doc(doc.id)
            .collection('contacts')
            .get();

        print('Contacts snapshot for ${doc.id}: ${contactsSnapshot.docs.length} contacts found');
        
        if (contactsSnapshot.docs.isNotEmpty) {
          final contactData = contactsSnapshot.docs.first.data();
          print('Contact data: $contactData');
          
          if (contactData.containsKey('contacts')) {
            final contactsArray = contactData['contacts'] as List<dynamic>;
            List<Map<String, dynamic>> contactsList = [];
            
            for (var contact in contactsArray.take(3)) {
              final phoneNumber = (contact['phones'] as List<dynamic>?)?.first.toString() ?? '';
              final displayName = contact['displayName'] as String? ?? 'Unknown';
              
              // Find the contact in phone's contacts
              final phoneContact = await _findContactByPhone(phoneNumber);
              
              contactsList.add({
                'displayName': displayName,
                'phoneNumber': phoneNumber,
                'avatar': phoneContact?.avatar,
              });
            }
            
            print('Processed contacts list: $contactsList');
            allContacts.add(contactsList);
          } else {
            print('No contacts array found in document');
            allContacts.add([]);
          }
        } else {
          print('No contacts found for ${doc.id}');
          allContacts.add([]);
        }

        // Get positive_feelings data
        final positiveFeelingsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('logs')
            .doc(doc.id)
            .collection('positive_feelings')
            .get();

        if (positiveFeelingsSnapshot.docs.isNotEmpty) {
          final feelingsList = positiveFeelingsSnapshot.docs.take(4).map((feelingDoc) {
            final data = feelingDoc.data();
            print('Positive feeling data: $data');
            // Check if the document has a 'title' field
            if (data.containsKey('title') && data['title'] != null) {
              return data['title'] as String;
            }
            // If no title field, try to get the document ID
            return feelingDoc.id;
          }).where((title) => title.isNotEmpty).toList();
          
          print('Positive feelings: $feelingsList');
          if (feelingsList.isNotEmpty) {
            positiveFeelings = feelingsList;
          }
        }
      }

      print('All contacts: $allContacts');
      print('Final logContacts: ${allContacts.isNotEmpty ? allContacts.first : []}');

      setState(() {
        logCount = logsSnapshot.docs.length;
        logTimes = times;
        logMoods = moods;
        toggledIcons = allIcons.isNotEmpty ? allIcons.first : [];
        logContacts = allContacts.isNotEmpty ? allContacts.first : [];
        print('State updated with ${logContacts.length} contacts');
        hasLogs = logCount > 0;
        isLoading = false;
      });
    } catch (e) {
      print('Error checking for logs: $e');
      setState(() {
        hasLogs = false;
        logCount = 0;
        logTimes = [];
        logMoods = [];
        toggledIcons = [];
        logContacts = [];
        positiveFeelings = [];
        isLoading = false;
      });
    }
  }

  String getFormattedDate() {
    final days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final months = ['JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE', 
                   'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'];
    
    return '${days[selectedDate.weekday - 1]}, ${months[selectedDate.month - 1]} ${selectedDate.day}';
  }

  String formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final oneYearAgo = now.subtract(Duration(days: 365));
    
    if (selectedDate.isBefore(oneYearAgo)) {
      selectedDate = oneYearAgo;
    } else if (selectedDate.isAfter(now)) {
      selectedDate = now;
    }

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
                            setState(() {});
                            _checkForLogs(); // Check for logs when date changes
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
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                          pickerTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        initialDateTime: selectedDate,
                        mode: CupertinoDatePickerMode.dateAndTime,
                        maximumDate: now,
                        minimumDate: oneYearAgo,
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newDateTime) {
                          setState(() {
                            selectedDate = newDateTime;
                          });
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
          child: Column(
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
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    HomescreenScreen.builder(context),
                              ),
                            );
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
                                'Home',
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
                      'History',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = selectedDate.subtract(Duration(days: 1));
                        });
                        _checkForLogs();
                      },
                      child: Transform.translate(
                      offset: Offset(4, 0.3),
                      child: Container(
                        child: SvgPicture.asset(
                          'assets/images/chevronl.svg',
                          width: 7,
                          height: 13,
                          colorFilter: ColorFilter.mode(
                            Colors.white.withOpacity(1),
                            BlendMode.srcIn,
                          ),
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Text(
                        getFormattedDate(),
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                              color: Colors.black.withOpacity(0.25),
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = selectedDate.add(Duration(days: 1));
                        });
                        _checkForLogs();
                      },
                      child: Transform.translate(
                      offset: Offset(-4, 0.3),
                      child: Container(
                        child: Transform.rotate(
                            angle: 3.14159,
                          child: SvgPicture.asset(
                            'assets/images/chevronl.svg',
                            width: 7,
                            height: 13,
                            colorFilter: ColorFilter.mode(
                              Colors.white.withOpacity(1),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : hasLogs && logTimes.isNotEmpty && logMoods.isNotEmpty
                        ? SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(
                                logCount,
                                (index) => Padding(
                                  padding: EdgeInsets.only(
                                    top: index == 0 ? 20.0 : 11.0,
                                  ),
                                  child: Stack(
                                    alignment: Alignment.topLeft,
                                    children: [
                                      Center(
                                        child: SvgPicture.asset(
                                          'assets/images/history_preview.svg',
                                          width: 340,
                                          height: 178,
                                        ),
                                      ),
                                      Positioned(
                                        left: 51,
                                        top: 15,
                                        child: Text(
                                          formatTime(logTimes[index]),
                                          style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 51,
                                        top: 34,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              logMoods[index],
                                              style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (toggledIcons.isNotEmpty || logContacts.isNotEmpty) ...[
                                              SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  if (toggledIcons.isNotEmpty) ...[
                                                    ...toggledIcons.take(3).map((icon) {
                                                      String iconPath = 'assets/images/${icon.toLowerCase()}.svg';
                                                      if (icon == 'Music') {
                                                        iconPath = 'assets/images/music_2.svg';
                                                      }
                                                      return Padding(
                                                        padding: EdgeInsets.only(right: 4),
                                                        child: SvgPicture.asset(
                                                          iconPath,
                                                          width: 26.62,
                                                          height: 26,
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ],
                                                  if (logContacts.isNotEmpty) ...[
                                                    if (toggledIcons.isNotEmpty) SizedBox(width: 4),
                                                    ...logContacts.map((contact) {
                                                      print('Rendering contact: ${contact['displayName']}');
                                                      return Padding(
                                                        padding: EdgeInsets.only(right: 4),
                                                        child: CircleAvatar(
                                                          radius: 13,
                                                          backgroundColor: Colors.white.withOpacity(0.2),
                                                          backgroundImage: contact['avatar'] != null 
                                                            ? MemoryImage(contact['avatar'] as Uint8List)
                                                            : null,
                                                          child: contact['avatar'] == null 
                                                            ? Text(
                                                                contact['displayName'].substring(0, 1).toUpperCase(),
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              )
                                                            : null,
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ],
                                                ],
                                              ),
                                            ],
                                            if (positiveFeelings.isNotEmpty) ...[
                                              SizedBox(height: 4),
                                              Text(
                                                positiveFeelings.join(' · '),
                                                style: GoogleFonts.roboto(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Center(
                  child: Transform.translate(
                    offset: Offset(0, -10),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: -30,
                          child: Container(
                            width: 340,
                            height: 400,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.black.withOpacity(0.02),
                                  Color(0xFF666666).withOpacity(0.02),
                                ],
                                stops: [0.0, 0.54],
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/images/history_add.svg',
                          width: 340,
                          height: 342,
                        ),
                        Positioned(
                          top: 60,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                mainText,
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 2),
                              Text(
                                subText,
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LogInputScreen.builder(
                                    context,
                                    source: 'history'),
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
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.deepPurple,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
