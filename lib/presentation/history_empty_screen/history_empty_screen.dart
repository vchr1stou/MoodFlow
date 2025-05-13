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
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../../core/app_export.dart';
import '../log_input_screen/log_input_screen.dart';
import '../homescreen_screen/homescreen_screen.dart';
import '../history_preview_screen/history_preview_screen.dart';

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
  List<String> negativeFeelings = [];
  Map<String, dynamic>? spotifyTrack;
  List<String> photoUrls = [];
  QuerySnapshot? logsSnapshot;

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
      negativeFeelings = [];
      spotifyTrack = null;
      photoUrls = [];
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        setState(() {
          hasLogs = false;
          logCount = 0;
          isLoading = false;
        });
        return;
      }

      // Format the date as DD_MM_YYYY
      final dateStr = '${selectedDate.day.toString().padLeft(2, '0')}_${selectedDate.month.toString().padLeft(2, '0')}_${selectedDate.year}';
      
      // Get all logs for this date
      logsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .collection('logs')
          .where(FieldPath.documentId, isGreaterThanOrEqualTo: dateStr)
          .where(FieldPath.documentId, isLessThan: dateStr + '_z')
          .get();

      if (logsSnapshot == null || logsSnapshot!.docs.isEmpty) {
        setState(() {
          hasLogs = false;
          logCount = 0;
          isLoading = false;
        });
        return;
      }

      // Extract timestamps and moods
      final times = logsSnapshot!.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        final timestamp = data?['createdAt'] as Timestamp?;
        return timestamp?.toDate() ?? DateTime.now();
      }).toList();

      final moods = logsSnapshot!.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        return data?['mood'] as String? ?? 'N/A';
      }).toList();

      // Run all subcollection fetches in parallel
      final futures = logsSnapshot!.docs.map((doc) async {
        final whatsHappeningFuture = FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('logs')
            .doc(doc.id)
            .collection('whats_happening')
            .get();

        final contactsFuture = FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('logs')
            .doc(doc.id)
            .collection('contacts')
            .get();

        final positiveFeelingsFuture = FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('logs')
            .doc(doc.id)
            .collection('positive_feelings')
            .get();

        final negativeFeelingsFuture = FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('logs')
            .doc(doc.id)
            .collection('negative_feelings')
            .get();

        final spotifyFuture = FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('logs')
            .doc(doc.id)
            .collection('Spotify')
            .get();

        final photosFuture = FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('logs')
            .doc(doc.id)
            .collection('Photos')
            .doc('photo_urls')
            .get();

        final results = await Future.wait([
          whatsHappeningFuture,
          contactsFuture,
          positiveFeelingsFuture,
          negativeFeelingsFuture,
          spotifyFuture,
          photosFuture,
        ]);

        return {
          'whatsHappening': results[0],
          'contacts': results[1],
          'positiveFeelings': results[2],
          'negativeFeelings': results[3],
          'spotify': results[4],
          'photos': results[5],
        };
      }).toList();

      final allResults = await Future.wait(futures);

      // Process results
      List<List<String>> allIcons = [];
      List<List<Map<String, dynamic>>> allContacts = [];
      List<String> allPositiveFeelings = [];
      List<String> allNegativeFeelings = [];
      Map<String, dynamic>? allSpotifyTrack;
      List<String> allPhotoUrls = [];

      for (var result in allResults) {
        // Process whats_happening
        final whatsHappeningSnapshot = result['whatsHappening'] as QuerySnapshot?;
        if (whatsHappeningSnapshot?.docs.isNotEmpty ?? false) {
          final whatsHappeningData = whatsHappeningSnapshot!.docs.first.data() as Map<String, dynamic>?;
          if (whatsHappeningData?.containsKey('toggledIcons') ?? false) {
            final iconsList = whatsHappeningData!['toggledIcons'] as List<dynamic>?;
            allIcons.add(iconsList?.take(3).map((icon) => icon.toString()).toList() ?? []);
          } else {
            allIcons.add([]);
          }
        } else {
          allIcons.add([]);
        }

        // Process contacts
        final contactsSnapshot = result['contacts'] as QuerySnapshot?;
        if (contactsSnapshot?.docs.isNotEmpty ?? false) {
          final contactData = contactsSnapshot!.docs.first.data() as Map<String, dynamic>?;
          if (contactData?.containsKey('contacts') ?? false) {
            final contactsArray = contactData!['contacts'] as List<dynamic>;
            List<Map<String, dynamic>> contactsList = [];
            
            for (var contact in contactsArray.take(3)) {
              final phoneNumber = (contact['phones'] as List<dynamic>?)?.first.toString() ?? '';
              final displayName = contact['displayName'] as String? ?? 'Unknown';
              final phoneContact = await _findContactByPhone(phoneNumber);
              
              contactsList.add({
                'displayName': displayName,
                'phoneNumber': phoneNumber,
                'avatar': phoneContact?.avatar,
              });
            }
            
            allContacts.add(contactsList);
          } else {
            allContacts.add([]);
          }
        } else {
          allContacts.add([]);
        }

        // Process feelings
        final positiveFeelingsSnapshot = result['positiveFeelings'] as QuerySnapshot?;
        if (positiveFeelingsSnapshot?.docs.isNotEmpty ?? false) {
          final feelingsList = positiveFeelingsSnapshot!.docs.take(4).map((feelingDoc) {
            final data = feelingDoc.data() as Map<String, dynamic>?;
            final hasTitle = data?.containsKey('title') ?? false;
            final title = data?['title'];
            return hasTitle && title != null ? title as String : feelingDoc.id;
          }).where((title) => title != null && title.isNotEmpty).toList();
          
          if (feelingsList.isNotEmpty) {
            allPositiveFeelings = feelingsList;
          }
        }

        final negativeFeelingsSnapshot = result['negativeFeelings'] as QuerySnapshot?;
        if (negativeFeelingsSnapshot?.docs.isNotEmpty ?? false) {
          final feelingsList = negativeFeelingsSnapshot!.docs.take(4).map((feelingDoc) {
            final data = feelingDoc.data() as Map<String, dynamic>?;
            final hasTitle = data?.containsKey('title') ?? false;
            final title = data?['title'];
            return hasTitle && title != null ? title as String : feelingDoc.id;
          }).where((title) => title != null && title.isNotEmpty).toList();
          
          if (feelingsList.isNotEmpty) {
            allNegativeFeelings = feelingsList;
          }
        }

        // Process Spotify
        final spotifySnapshot = result['spotify'] as QuerySnapshot?;
        if (spotifySnapshot?.docs.isNotEmpty ?? false) {
          final trackData = spotifySnapshot!.docs.first.data() as Map<String, dynamic>?;
          final hasName = trackData?.containsKey('name') ?? false;
          final hasArtist = trackData?.containsKey('artist') ?? false;
          
          if (hasName && hasArtist) {
            allSpotifyTrack = {
              'name': trackData!['name'],
              'artist': trackData['artist'],
            };
          } else {
            final hasTrack = trackData?.containsKey('track') ?? false;
            if (hasTrack) {
              final track = trackData!['track'] as Map<String, dynamic>?;
              final trackHasName = track?.containsKey('name') ?? false;
              final trackHasArtist = track?.containsKey('artist') ?? false;
              
              if (trackHasName && trackHasArtist) {
                allSpotifyTrack = {
                  'name': track!['name'],
                  'artist': track['artist'],
                };
              }
            }
          }
        }

        // Process photos
        final photosSnapshot = result['photos'] as DocumentSnapshot?;
        if (photosSnapshot?.exists ?? false) {
          final photoData = photosSnapshot!.data() as Map<String, dynamic>?;
          if (photoData?.containsKey('urls') ?? false) {
            final urls = photoData!['urls'] as List<dynamic>;
            allPhotoUrls = urls.take(4).map((url) => url.toString()).toList();
          }
        }
      }

      setState(() {
        logCount = logsSnapshot!.docs.length;
        logTimes = times;
        logMoods = moods;
        toggledIcons = allIcons.isNotEmpty ? allIcons.first : [];
        logContacts = allContacts.isNotEmpty ? allContacts.first : [];
        positiveFeelings = allPositiveFeelings;
        negativeFeelings = allNegativeFeelings;
        spotifyTrack = allSpotifyTrack;
        photoUrls = allPhotoUrls;
        hasLogs = logCount > 0;
        isLoading = false;
      });
    } catch (e) {
      print('Error checking for logs: $e');
      setState(() {
        hasLogs = false;
        logCount = 0;
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
                        child: CupertinoActivityIndicator(
                          radius: 12,
                          color: Colors.white,
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
                                        child: GestureDetector(
                                          onTap: () {
                                            if (logsSnapshot != null) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => HistoryPreviewScreen.builder(
                                                    context,
                                                    logData: {
                                                      'mood': logMoods[index],
                                                      'time': formatTime(logTimes[index]),
                                                      'date': getFormattedDate(),
                                                      'photos': photoUrls,
                                                      'positiveFeelings': positiveFeelings,
                                                      'negativeFeelings': negativeFeelings,
                                                      'spotifyTrack': spotifyTrack,
                                                      'toggledIcons': toggledIcons,
                                                      'contacts': logContacts,
                                                      'documentId': logsSnapshot!.docs[index].id,
                                                    },
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        child: SvgPicture.asset(
                                          'assets/images/history_preview.svg',
                                          width: 340,
                                          height: 178,
                                        ),
                                      ),
                                      ),
                                      if (photoUrls.isNotEmpty)
                                        Positioned(
                                          left: 242,
                                          top: 14,
                                          child: GestureDetector(
                                            onTap: () {
                                              if (logsSnapshot != null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => HistoryPreviewScreen.builder(
                                                      context,
                                                      logData: {
                                                        'mood': logMoods[index],
                                                        'time': formatTime(logTimes[index]),
                                                        'date': getFormattedDate(),
                                                        'photos': photoUrls,
                                                        'positiveFeelings': positiveFeelings,
                                                        'negativeFeelings': negativeFeelings,
                                                        'spotifyTrack': spotifyTrack,
                                                        'toggledIcons': toggledIcons,
                                                        'contacts': logContacts,
                                                        'documentId': logsSnapshot!.docs[index].id,
                                                      },
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(12),
                                                      child: Image.network(
                                                        photoUrls[0],
                                                        width: 40,
                                                        height: 40,
                                              fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stackTrace) {
                                                          print('Error loading image: $error');
                                                          return Container(
                                                            width: 40,
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                              color: Colors.grey[300],
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            child: Icon(Icons.error, color: Colors.grey[600]),
                                                          );
                                                        },
                                                        loadingBuilder: (context, child, loadingProgress) {
                                                          if (loadingProgress == null) return child;
                                                          return Container(
                                                            width: 40,
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                              color: Colors.grey[300],
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            child: Center(
                                                              child: CircularProgressIndicator(
                                                                value: loadingProgress.expectedTotalBytes != null
                                                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                                    : null,
                                                                strokeWidth: 2,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    if (photoUrls.length > 2) ...[
                                                      SizedBox(height: 1),
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(12),
                                                        child: Image.network(
                                                          photoUrls[2],
                                                          width: 40,
                                                          height: 40,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (context, error, stackTrace) {
                                                            print('Error loading image: $error');
                                                            return Container(
                                                              width: 40,
                                                              height: 40,
                                                              decoration: BoxDecoration(
                                                                color: Colors.grey[300],
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              child: Icon(Icons.error, color: Colors.grey[600]),
                                                            );
                                                          },
                                                          loadingBuilder: (context, child, loadingProgress) {
                                                            if (loadingProgress == null) return child;
                                                            return Container(
                                                              width: 40,
                                                              height: 40,
                                                              decoration: BoxDecoration(
                                                                color: Colors.grey[300],
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              child: Center(
                                                                child: CircularProgressIndicator(
                                                                  value: loadingProgress.expectedTotalBytes != null
                                                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                                      : null,
                                                                  strokeWidth: 2,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                                if (photoUrls.length > 1) ...[
                                                  SizedBox(width: 1),
                                                  Column(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(12),
                                                        child: Image.network(
                                                          photoUrls[1],
                                                          width: 40,
                                                          height: 40,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (context, error, stackTrace) {
                                                            print('Error loading image: $error');
                                                            return Container(
                                                              width: 40,
                                                              height: 40,
                                                              decoration: BoxDecoration(
                                                                color: Colors.grey[300],
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              child: Icon(Icons.error, color: Colors.grey[600]),
                                                            );
                                                          },
                                                          loadingBuilder: (context, child, loadingProgress) {
                                                            if (loadingProgress == null) return child;
                                                            return Container(
                                                              width: 40,
                                                              height: 40,
                                                              decoration: BoxDecoration(
                                                                color: Colors.grey[300],
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              child: Center(
                                                                child: CircularProgressIndicator(
                                                                  value: loadingProgress.expectedTotalBytes != null
                                                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                                      : null,
                                                                  strokeWidth: 2,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      if (photoUrls.length > 3) ...[
                                                        SizedBox(height: 1),
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(12),
                                                          child: Image.network(
                                                            photoUrls[3],
                                                            width: 40,
                                                            height: 40,
                                                            fit: BoxFit.cover,
                                                            errorBuilder: (context, error, stackTrace) {
                                                              print('Error loading image: $error');
                                                              return Container(
                                                                width: 40,
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.grey[300],
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                child: Icon(Icons.error, color: Colors.grey[600]),
                                                              );
                                                            },
                                                            loadingBuilder: (context, child, loadingProgress) {
                                                              if (loadingProgress == null) return child;
                                                              return Container(
                                                                width: 40,
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.grey[300],
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                child: Center(
                                                                  child: CircularProgressIndicator(
                                                                    value: loadingProgress.expectedTotalBytes != null
                                                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                                        : null,
                                                                    strokeWidth: 2,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                      Positioned(
                                        right: 40,
                                        top: 3,
                                        bottom: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (logsSnapshot != null) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => HistoryPreviewScreen.builder(
                                                    context,
                                                    logData: {
                                                      'mood': logMoods[index],
                                                      'time': formatTime(logTimes[index]),
                                                      'date': getFormattedDate(),
                                                      'photos': photoUrls,
                                                      'positiveFeelings': positiveFeelings,
                                                      'negativeFeelings': negativeFeelings,
                                                      'spotifyTrack': spotifyTrack,
                                                      'toggledIcons': toggledIcons,
                                                      'contacts': logContacts,
                                                      'documentId': logsSnapshot!.docs[index].id,
                                                    },
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: SvgPicture.asset(
                                            'assets/images/right_chevron_history.svg',
                                            width: 15.88,
                                            height: 22.99,
                                            ),
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
                                            ] else ...[
                                              SizedBox(height: 4),
                                              Text(
                                                'No positive feelings logged',
                                                style: GoogleFonts.roboto(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                            if (negativeFeelings.isNotEmpty) ...[
                                              SizedBox(height: 4),
                                              Text(
                                                negativeFeelings.join(' · '),
                                                style: GoogleFonts.roboto(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ] else ...[
                                              SizedBox(height: 4),
                                              Text(
                                                'No negative feelings logged',
                                                style: GoogleFonts.roboto(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                            if (spotifyTrack != null) ...[
                                              SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/images/spotify_small.svg',
                                                    width: 16,
                                                    height: 16,
                                                  ),
                                                  SizedBox(width: 3),
                                                  Text(
                                                    '${spotifyTrack!['name']} · ${spotifyTrack!['artist']}',
                                                    style: GoogleFonts.roboto(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
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
