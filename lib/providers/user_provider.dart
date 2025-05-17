import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../services/notification_service.dart';


class UserProvider extends ChangeNotifier {
  String? name;
  String? pronouns;
  String? email;
  String? password;

  // Used for Profile Picture
  String? profilePicUrl;
  File? profilePicFile;

  // Used for Daily Check-in Reminders
  List<TimeOfDay> dailyCheckInTimes = [];
  List<bool>? dailyCheckInEnabled;
  bool? dailyCheckInSectionEnabled;
  List<String>? dailyCheckInDescriptions;

  // Used for Quote Reminder
  TimeOfDay? quoteReminderTime;
  bool? quoteReminderEnabled;
  bool? quoteReminderSectionEnabled;
  
  // Used for Safety Net    
  List<Contact> contacts = [];
  String? spotifyToken;

  // Used for Daily Streak Reminder
  bool dailyStreakEnabled = true;
  TimeOfDay dailyStreakTime = const TimeOfDay(hour: 23, minute: 30);

  List<String?> _dailyCheckInMessages = ["Time for your daily check-in!", "Time for your daily check-in!", "Time for your daily check-in!", "Time for your daily check-in?"];
  List<String?> _dailyCheckInTitles = ["How are you feeling?", "How are you feeling?", "How are you feeling?", "How are you feeling?"];
  
  List<String?> get dailyCheckInMessages => _dailyCheckInMessages;
  List<String?> get dailyCheckInTitles => _dailyCheckInTitles;

  final NotificationService _notificationService = NotificationService();

  Future<void> toggleDailyStreak(bool value) async {
    if (email == null) return;
    dailyStreakEnabled = value;
    await FirebaseFirestore.instance.collection('users').doc(email).update({'dailyStreakEnabled': value});
    notifyListeners();
  }

  Future<void> updateStreakReminderTime(TimeOfDay newTime) async {
    if (email == null) return;
    dailyStreakTime = newTime;
    await FirebaseFirestore.instance.collection('users').doc(email).update({
      'dailyStreakTime': {
        'hour': newTime.hour,
        'minute': newTime.minute,
      }
    });
    notifyListeners();
  }

  Future<void> deleteStreakReminder() async {
    if (email == null) return;
    dailyStreakEnabled = false;
    await FirebaseFirestore.instance.collection('users').doc(email).update({
      'dailyStreakEnabled': false,
      'dailyStreakTime': null,
    });
    notifyListeners();
  }

  Future<void> toggleCheckInReminder(bool value) async {
    if (email == null) return;
    debugPrint('Toggling check-in reminder to: $value');
    
    dailyCheckInSectionEnabled = value;
    await FirebaseFirestore.instance.collection('users').doc(email).update({'dailyCheckInSectionEnabled': value});
    
    if (value) {
      debugPrint('Enabling check-in reminders');
      await _scheduleNotifications();
    } else {
      debugPrint('Disabling check-in reminders');
      // Cancel all check-in notifications but keep quote reminder if enabled
      for (int i = 0; i < dailyCheckInTimes.length; i++) {
        await _notificationService.cancelNotification(i);
      }
    }
    
    notifyListeners();
  }

  Future<void> toggleQuoteReminder(bool value) async {
    if (email == null) return;
    debugPrint('Toggling quote reminder to: $value');
    
    quoteReminderEnabled = value;
    await FirebaseFirestore.instance.collection('users').doc(email).update({'quoteReminderEnabled': value});
    
    if (value && quoteReminderTime != null) {
      final now = DateTime.now();
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        quoteReminderTime!.hour,
        quoteReminderTime!.minute,
      );
      debugPrint('Enabling quote reminder');
      await _notificationService.scheduleQuoteReminder(scheduledTime: scheduledTime);
    } else {
      debugPrint('Disabling quote reminder');
      await _notificationService.cancelNotification(100); // Cancel quote reminder
    }
    
    notifyListeners();
  }
  

  void updateStepOneData(String name, String pronouns, String email, String password) {
    this.name = name;
    this.pronouns = pronouns;
    this.email = email;
    this.password = password;
    notifyListeners();
  }

  void updateStepTwoData(List<TimeOfDay> dailyCheckInTimes, List<bool> dailyCheckInEnabled,
                         TimeOfDay quoteReminderTime, bool quoteReminderEnabled) {
    this.dailyCheckInTimes = dailyCheckInTimes;
    this.dailyCheckInEnabled = dailyCheckInEnabled;
    this.quoteReminderTime = quoteReminderTime;
    this.quoteReminderEnabled = quoteReminderEnabled;
    notifyListeners();
  }

  void updateStepThreeData(List<Contact> contacts) {
    this.contacts = contacts;
    notifyListeners();
  }

  Future<void> fetchUserData(String email) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(email).get();
    if (userDoc.exists) {
      final data = userDoc.data()!;
      name = data['name'];
      pronouns = data['pronouns'];
      this.email = data['email'];
      profilePicUrl = data['profilePicUrl'];
      
      // Add null checks for dailyCheckInTitles
      final checkInTitlesData = data['dailyCheckInTitles'];
      if (checkInTitlesData != null && checkInTitlesData is List) {
        _dailyCheckInTitles = checkInTitlesData.cast<String?>();
      }
      
      if (profilePicUrl != null) {
        try {
          final ref = FirebaseStorage.instance.refFromURL(profilePicUrl!);
          final bytes = await ref.getData();
          if (bytes != null) {
            final tempDir = await getTemporaryDirectory();
            final file = File('${tempDir.path}/profile_pic.jpg');
            await file.writeAsBytes(bytes);
            profilePicFile = file;
          }
        } catch (e) {
          print('Error loading profile picture: $e');
        }
      }
      
      // Add null checks for dailyCheckInTimes
      final checkInTimesData = data['dailyCheckInTimes'];
      if (checkInTimesData != null && checkInTimesData is List) {
        dailyCheckInTimes = checkInTimesData
            .map((time) => TimeOfDay(hour: time['hour'], minute: time['minute']))
            .toList();
      } else {
        dailyCheckInTimes = [];
      }

      // Add null checks for dailyCheckInEnabled
      final checkInEnabledData = data['dailyCheckInEnabled'];
      if (checkInEnabledData != null && checkInEnabledData is List) {
        dailyCheckInEnabled = checkInEnabledData.cast<bool>();
      } else {
        dailyCheckInEnabled = [];
      }

      // Add null checks for quoteReminderTime
      final quoteTimeData = data['quoteReminderTime'];
      if (quoteTimeData != null) {
        quoteReminderTime = TimeOfDay(
          hour: quoteTimeData['hour'],
          minute: quoteTimeData['minute']
        );
      }
      quoteReminderEnabled = data['quoteReminderEnabled'];

      // Fetch contacts from the safetynet subcollection
      final safetynetCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection('safetynet');
      final contactsSnapshot = await safetynetCollection.get();
      contacts = [];

      for (var doc in contactsSnapshot.docs) {
        final contactNumber = doc.data()['phone'];
        if (contactNumber != null) {
          final contact = Contact(phones: [Item(label: 'mobile', value: contactNumber)]);
          contacts.add(contact);
        }
      }

      // Schedule notifications for enabled check-ins
      await _scheduleNotifications();
    }
  }

  Future<void> _scheduleNotifications() async {
    debugPrint('Scheduling notifications...');
    debugPrint('dailyCheckInSectionEnabled: $dailyCheckInSectionEnabled');
    debugPrint('quoteReminderEnabled: $quoteReminderEnabled');
    
    if (dailyCheckInEnabled == null || dailyCheckInTimes.isEmpty || dailyCheckInSectionEnabled != true) {
      debugPrint('Skipping daily check-in notifications - conditions not met');
      return;
    }

    // Cancel existing notifications
    await _notificationService.cancelAllNotifications();

    // Schedule new notifications for enabled check-ins
    for (int i = 0; i < dailyCheckInTimes.length; i++) {
      if (dailyCheckInEnabled![i]) {
        final time = dailyCheckInTimes[i];
        final now = DateTime.now();
        final scheduledTime = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );

        final title = _dailyCheckInTitles[i] ?? "How are you feeling?";
        final message = _dailyCheckInMessages[i] ?? "Time for your daily check-in!";

        debugPrint('Scheduling check-in $i at ${time.hour}:${time.minute}');
        await _notificationService.scheduleDailyCheckIn(
          id: i,
          scheduledTime: scheduledTime,
          title: title,
          body: message,
        );
      }
    }

    // Schedule quote reminder if enabled
    if (quoteReminderEnabled == true && quoteReminderTime != null) {
      final now = DateTime.now();
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        quoteReminderTime!.hour,
        quoteReminderTime!.minute,
      );
      debugPrint('Scheduling quote reminder at ${quoteReminderTime!.hour}:${quoteReminderTime!.minute}');
      await _notificationService.scheduleQuoteReminder(scheduledTime: scheduledTime);
    }
  }

  Stream<DocumentSnapshot> get userStream {
    if (email == null) {
      throw Exception('Email is not set. Please fetch user data first.');
    }
    return FirebaseFirestore.instance.collection('users').doc(email).snapshots();
  }

  Future<void> createUser(ScaffoldMessengerState messenger) async {
    try {
      // Create user in Firebase Authentication
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      // Save additional user data in Firestore
      final userId = credential.user?.email;
      if (userId != null) {
        dailyCheckInDescriptions = [];
        for (int i = 0; i < dailyCheckInTimes.length; i++) {
          if (dailyCheckInTimes[i].hour < 12) {
            dailyCheckInDescriptions!.add('Time for your morning check-in!');
          } else if (dailyCheckInTimes[i].hour >= 12 && dailyCheckInTimes[i].hour < 18) {
            dailyCheckInDescriptions!.add('Time for your afternoon check-in!');
          } else {
            dailyCheckInDescriptions!.add('Time for your evening check-in!');
          }
        }

        final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
        await userDoc.set({
          'name': name,
          'pronouns': pronouns,
          'email': email,
          // Daily Check-in Reminders
          'dailyCheckInTimes': dailyCheckInTimes.map((time) => {
            'hour': time.hour,
            'minute': time.minute,
          }).toList(),
          'dailyCheckInEnabled': dailyCheckInEnabled ?? List.generate(dailyCheckInTimes.length, (_) => true),
          'dailyCheckInSectionEnabled': dailyCheckInSectionEnabled ?? true,
          'dailyCheckInDescriptions': dailyCheckInDescriptions,
          // Quote Reminder
          'quoteReminderTime': quoteReminderTime != null
              ? {
                  'hour': quoteReminderTime!.hour,
                  'minute': quoteReminderTime!.minute,
                }
              : null,
          'quoteReminderEnabled': quoteReminderEnabled ?? false,
          'quoteReminderSectionEnabled': quoteReminderSectionEnabled ?? true,
          // Streak Reminder
          'dailyStreakTime': dailyStreakTime != null
              ? {
                  'hour': dailyStreakTime!.hour,
                  'minute': dailyStreakTime!.minute,
                }
              : null,
          'dailyStreakEnabled': dailyStreakEnabled ?? false,
          'createdAt': FieldValue.serverTimestamp(),
          'dailyCheckInTitles': _dailyCheckInTitles,
          'dailyCheckInMessages': _dailyCheckInMessages,
        });

        // Create safetynet subcollection
        final safetynetCollection = userDoc.collection('safetynet');
        for (int i = 0; i < contacts.length; i++) {
          final contact = contacts[i];
          await safetynetCollection.doc('person${i + 1}').set({
            'number': contact.phones?.isNotEmpty == true ? contact.phones!.first.value : null,
          });
        }
      }

      debugPrint('User created and data saved: $userId');
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'email-already-in-use') {
        message = 'This email is already registered. Please log in or use another email.';
      } else {
        message = 'Error creating user: ${e.message}';
      }
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: const Color.fromARGB(255, 0, 0, 0)),
              SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
            textColor: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      );
      rethrow;
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('An unexpected error occurred.')),
      );
      rethrow;
    }
  }

  Future<void> updateProfilePic(File imageFile) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(user.uid)
          .child('profile_pic.jpg');

      final uploadTask = await storageRef.putFile(imageFile);
      if (uploadTask.state == TaskState.success) {
        final downloadUrl = await storageRef.getDownloadURL();
        profilePicUrl = downloadUrl;
        profilePicFile = imageFile;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .update({'profilePicUrl': downloadUrl});
        notifyListeners();
      }
    } catch (e) {
      print('Error uploading profile picture: $e');
      rethrow;
    }
  }

  Future<void> updateName(String newName) async {
    if (email == null) return;
    name = newName;
    await FirebaseFirestore.instance.collection('users').doc(email).update({'name': newName});
    notifyListeners();
  }

  Future<void> updatePronouns(String newPronouns) async {
    if (email == null) return;
    pronouns = newPronouns;
    await FirebaseFirestore.instance.collection('users').doc(email).update({'pronouns': newPronouns});
    notifyListeners();
  }

  Future<void> updateEmail(String newEmail) async {
    if (email == null) return;
    // Update in Firebase Auth
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateEmail(newEmail);
    }
    // Update in Firestore
    await FirebaseFirestore.instance.collection('users').doc(email).update({'email': newEmail});
    email = newEmail;
    notifyListeners();
  }

  Future<void> updatePassword(String newPassword) async {
    if (email == null) return;
    // Update in Firebase Auth
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    }

    password = newPassword;
    notifyListeners();
  }

  Future<void> deleteProfilePic() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Delete from Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(user.uid)
          .child('profile_pic.jpg');
      
      await storageRef.delete();

      // Update Firestore and local state
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .update({'profilePicUrl': null});

      profilePicUrl = null;
      profilePicFile = null;
      notifyListeners();
    } catch (e) {
      print('Error deleting profile picture: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    name = null;
    pronouns = null;
    email = null;
    password = null;
    profilePicUrl = null;
    dailyCheckInTimes = [];
    dailyCheckInEnabled = null;
    quoteReminderTime = null;
    quoteReminderEnabled = null;
    contacts = [];
    spotifyToken = null;
    dailyStreakEnabled = true;
    dailyStreakTime = const TimeOfDay(hour: 23, minute: 30);
    dailyCheckInDescriptions = null;
    notifyListeners();
  }

  Future<void> updateDailyCheckInTime(int index, TimeOfDay newTime) async {
    if (email == null) return;
    if (index >= 0 && index < dailyCheckInTimes.length) {
      dailyCheckInTimes[index] = newTime;
      await FirebaseFirestore.instance.collection('users').doc(email).update({
        'dailyCheckInTimes': dailyCheckInTimes.map((time) => {
          'hour': time.hour,
          'minute': time.minute,
        }).toList(),
      });
      await _scheduleNotifications();
      notifyListeners();
    }
  }

  Future<void> updateQuoteReminderTime(TimeOfDay newTime) async {
    if (email == null) return;
    debugPrint('Updating quote reminder time to ${newTime.hour}:${newTime.minute}');
    
    quoteReminderTime = newTime;
    await FirebaseFirestore.instance.collection('users').doc(email).update({
      'quoteReminderTime': {
        'hour': newTime.hour,
        'minute': newTime.minute,
      }
    });
    
    // Schedule quote reminder notification only if enabled
    if (quoteReminderEnabled == true) {
      final now = DateTime.now();
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        newTime.hour,
        newTime.minute,
      );
      debugPrint('Scheduling new quote reminder');
      await _notificationService.scheduleQuoteReminder(scheduledTime: scheduledTime);
    }
    
    notifyListeners();
  }

  Future<void> toggleDailyCheckIn(int index, bool value) async {
    if (email == null) return;
    if (index >= 0 && index < (dailyCheckInEnabled?.length ?? 0)) {
      dailyCheckInEnabled![index] = value;
      await FirebaseFirestore.instance.collection('users').doc(email).update({
        'dailyCheckInEnabled': dailyCheckInEnabled,
      });
      await _scheduleNotifications();
      notifyListeners();
    }
  }

  Future<void> updateDailyCheckInMessage(int index, String message) async {
    if (index >= 0 && index < _dailyCheckInMessages.length) {
      _dailyCheckInMessages[index] = message;
      await _scheduleNotifications();
      notifyListeners();
    }
  }

  Future<void> updateDailyCheckInTitle(int index, String title) async {
    if (email == null) return;
    _dailyCheckInTitles[index] = title;
    await FirebaseFirestore.instance.collection('users').doc(email).update({
      'dailyCheckInTitles': _dailyCheckInTitles
    });
    await _scheduleNotifications();
    notifyListeners();
  }
}