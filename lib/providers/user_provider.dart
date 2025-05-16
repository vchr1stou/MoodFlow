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
  TimeOfDay? dailyStreakTime;
  bool? dailyStreakEnabled;
  bool? dailyStreakSectionEnabled;
  bool? dailyStreakReminderEnabled;

  // Notification IDs
  int _dailyCheckInNotificationId(int index) => 100 + index;
  int get _quoteNotificationId => 200;
  int get _streakNotificationId => 300;

  Future<void> toggleDailyStreak(bool value) async {
    if (email == null) return;
    dailyStreakEnabled = value;
    await FirebaseFirestore.instance.collection('users').doc(email).update({'dailyStreakEnabled': value});
    notifyListeners();
  }

  Future<void> toggleDailyStreakSection(bool value) async {
    if (email == null) return;
    dailyStreakSectionEnabled = value;
    await FirebaseFirestore.instance.collection('users').doc(email).update({'dailyStreakEnabled': value});
    notifyListeners();
  }


  Future<void> toggleCheckInReminder(bool value) async {
    if (email == null) return;
    dailyCheckInSectionEnabled = value;
    await FirebaseFirestore.instance.collection('users').doc(email).update({'dailyCheckInSectionEnabled': value});
    
    if (!value) {
      // Cancel all daily check-in notifications
      for (int i = 0; i < 4; i++) {
        await NotificationService().cancelNotification(_dailyCheckInNotificationId(i));
      }
    } else {
      // Reschedule all enabled daily check-in notifications
      for (int i = 0; i < dailyCheckInEnabled!.length; i++) {
        if (dailyCheckInEnabled![i]) {
          await NotificationService().scheduleDailyNotification(
            id: _dailyCheckInNotificationId(i),
            title: 'Daily Check-in',
            body: dailyCheckInDescriptions?[i] ?? 'Time for your daily check-in!',
            time: dailyCheckInTimes[i],
          );
        }
      }
    }
    notifyListeners();
  }

  Future<void> toggleQuoteReminder(bool value) async {
    if (email == null) return;
    quoteReminderSectionEnabled = value;
    await FirebaseFirestore.instance.collection('users').doc(email).update({'quoteReminderSectionEnabled': value});
    
    if (!value) {
      await NotificationService().cancelNotification(_quoteNotificationId);
    } else if (quoteReminderTime != null) {
      await NotificationService().scheduleDailyNotification(
        id: _quoteNotificationId,
        title: 'Quote of the Day',
        body: 'Your daily quote is ready!',
        time: quoteReminderTime!,
      );
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

      // Daily Check-in Reminders
      dailyCheckInTimes = (data['dailyCheckInTimes'] as List?)
          ?.map((time) => TimeOfDay(hour: time['hour'], minute: time['minute']))
          .toList() ?? [];
      dailyCheckInEnabled = (data['dailyCheckInEnabled'] as List?)?.cast<bool>() ?? [];
      dailyCheckInSectionEnabled = data['dailyCheckInSectionEnabled'] ?? false;
      dailyCheckInDescriptions = (data['dailyCheckInDescriptions'] as List?)?.cast<String>() ?? [];

      // Quote Reminder
      if (data['quoteReminderTime'] != null) {
        quoteReminderTime = TimeOfDay(
          hour: data['quoteReminderTime']['hour'],
          minute: data['quoteReminderTime']['minute'],
        );
      } else {
        quoteReminderTime = null;
      }
      quoteReminderEnabled = data['quoteReminderEnabled'] ?? false;
      quoteReminderSectionEnabled = data['quoteReminderSectionEnabled'] ?? false;

      // Streak Reminder
      if (data['dailyStreakTime'] != null) {
        dailyStreakTime = TimeOfDay(
          hour: data['dailyStreakTime']['hour'],
          minute: data['dailyStreakTime']['minute'],
        );
      } else {
        dailyStreakTime = null;
      }
      dailyStreakEnabled = data['dailyStreakEnabled'] ?? false;
      dailyStreakSectionEnabled = data['dailyStreakSectionEnabled'] ?? false;
      dailyStreakReminderEnabled = data['dailyStreakReminderEnabled'] ?? false;

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
      notifyListeners();
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
        // Initialize daily check-in descriptions if not already set
        if (dailyCheckInDescriptions == null || dailyCheckInDescriptions!.isEmpty) {
          dailyCheckInDescriptions = [];
          for (int i = 0; i < dailyCheckInTimes.length; i++) {
            if (dailyCheckInTimes[i].hour < 12) {
              dailyCheckInDescriptions!.add('Good Morning, how are you feeling?');
            } else if (dailyCheckInTimes[i].hour >= 12 && dailyCheckInTimes[i].hour < 18) {
              dailyCheckInDescriptions!.add('How has your day been so far?');
            } else {
              dailyCheckInDescriptions!.add('Good evening, how was your day?');
            }
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
          'dailyStreakSectionEnabled': dailyStreakSectionEnabled ?? true,
          'dailyStreakReminderEnabled': dailyStreakReminderEnabled ?? false,
          'createdAt': FieldValue.serverTimestamp(),
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
    if (index >= 0 && index < dailyCheckInTimes.length) {
      dailyCheckInTimes[index] = newTime;
      await FirebaseFirestore.instance.collection('users').doc(email).update({'dailyCheckInTimes': dailyCheckInTimes.map((time) => {
        'hour': time.hour,
        'minute': time.minute,
      }).toList()});
      // Schedule notification
      await NotificationService().scheduleDailyNotification(
        id: _dailyCheckInNotificationId(index),
        title: 'Daily Check-in',
        body: dailyCheckInDescriptions?[index] ?? 'Time for your daily check-in!',
        time: newTime,
      );
      notifyListeners();
    }
  }

  Future<void> updateQuoteReminderTime(TimeOfDay newTime) async {
    quoteReminderTime = newTime;
    await FirebaseFirestore.instance.collection('users').doc(email).update({'quoteReminderTime': {
      'hour': newTime.hour,
      'minute': newTime.minute,
    }});
    // Schedule notification
    await NotificationService().scheduleDailyNotification(
      id: _quoteNotificationId,
      title: 'Quote of the Day',
      body: 'Your daily quote is ready!',
      time: newTime,
    );
    notifyListeners();
  }

  Future<void> updateDailyStreakTime(TimeOfDay newTime) async {
    dailyStreakTime = newTime;
    await FirebaseFirestore.instance.collection('users').doc(email).update({'dailyStreakTime': {
      'hour': newTime.hour,
      'minute': newTime.minute,
    }});
    // Schedule notification
    await NotificationService().scheduleDailyNotification(
      id: _streakNotificationId,
      title: 'Daily Streak',
      body: 'Don\'t forget to keep your streak going!',
      time: newTime,
    );
    notifyListeners();
  }

  Future<void> disableDailyCheckIn(int index) async {
    if (index >= 0 && index < dailyCheckInEnabled!.length) {
      dailyCheckInEnabled![index] = false;
      await FirebaseFirestore.instance.collection('users').doc(email).update({'dailyCheckInEnabled': dailyCheckInEnabled});
      
      // Cancel notification
      print('Cancelling daily check-in notification for index $index');
      await NotificationService().cancelNotification(_dailyCheckInNotificationId(index));
      notifyListeners();
    }
  }

  Future<void> enableDailyCheckIn(int index, TimeOfDay time) async {
    if (index >= 0 && index < 4) {  // Ensure we stay within bounds
      if (dailyCheckInEnabled == null) dailyCheckInEnabled = List.filled(4, false);
      if (dailyCheckInTimes.isEmpty) dailyCheckInTimes = List.filled(4, const TimeOfDay(hour: 9, minute: 0));
      if (dailyCheckInDescriptions == null) dailyCheckInDescriptions = List.filled(4, '');

      dailyCheckInEnabled![index] = true;
      dailyCheckInTimes[index] = time;
      String description;
      if (time.hour < 12) {
        description = 'Good Morning, how are you feeling?';
      } else if (time.hour >= 12 && time.hour < 18) {
        description = 'How has your day been so far?';
      } else {
        description = 'Good evening, how was your day?';
      }
      dailyCheckInDescriptions![index] = description;

      await FirebaseFirestore.instance.collection('users').doc(email).update({
        'dailyCheckInEnabled': dailyCheckInEnabled,
        'dailyCheckInTimes': dailyCheckInTimes.map((time) => {
          'hour': time.hour,
          'minute': time.minute,
        }).toList(),
        'dailyCheckInDescriptions': dailyCheckInDescriptions
      });

      // Schedule notification
      print('Scheduling daily check-in notification for index $index at ${time.hour}:${time.minute}');
      await NotificationService().scheduleDailyNotification(
        id: _dailyCheckInNotificationId(index),
        title: 'Daily Check-in',
        body: description,
        time: time,
      );
      notifyListeners();
    }
  }

  Future<void> disableDailyStreak() async {
    dailyStreakReminderEnabled = false;
    await FirebaseFirestore.instance.collection('users').doc(email).update({'dailyStreakEnabled': false, 'dailyStreakReminderEnabled': false});
    
    // Cancel notification
    print('Cancelling daily streak notification');
    await NotificationService().cancelNotification(_streakNotificationId);
    notifyListeners();
  }

  Future<void> enableDailyStreak(TimeOfDay time) async {
    dailyStreakTime = time;
    dailyStreakEnabled = true;
    dailyStreakSectionEnabled = true;
    dailyStreakReminderEnabled = true;
    await FirebaseFirestore.instance.collection('users').doc(email).update({
      'dailyStreakTime': {
        'hour': time.hour,
        'minute': time.minute,
      },
      'dailyStreakEnabled': true,
      'dailyStreakSectionEnabled': true,
      'dailyStreakReminderEnabled': true
    });

    // Schedule notification
    print('Scheduling daily streak notification at ${time.hour}:${time.minute}');
    await NotificationService().scheduleDailyNotification(
      id: _streakNotificationId,
      title: 'Daily Streak',
      body: 'Don\'t forget to keep your streak going!',
      time: time,
    );
    notifyListeners();
  }

  Future<void> disableQuoteReminder() async {
    quoteReminderEnabled = false;
    await FirebaseFirestore.instance.collection('users').doc(email).update({'quoteReminderEnabled': false});
    
    // Cancel notification
    print('Cancelling quote reminder notification');
    await NotificationService().cancelNotification(_quoteNotificationId);
    notifyListeners();
  }

  Future<void> enableQuoteReminder(TimeOfDay time) async {
    quoteReminderTime = time;
    quoteReminderEnabled = true;
    quoteReminderSectionEnabled = true;
    await FirebaseFirestore.instance.collection('users').doc(email).update({
      'quoteReminderTime': {
        'hour': time.hour,
        'minute': time.minute,
      },
      'quoteReminderEnabled': true,
      'quoteReminderSectionEnabled': true
    });

    // Schedule notification
    print('Scheduling quote reminder notification at ${time.hour}:${time.minute}');
    await NotificationService().scheduleDailyNotification(
      id: _quoteNotificationId,
      title: 'Quote of the Day',
      body: 'Your daily quote is ready!',
      time: time,
    );
    notifyListeners();
  }

}