import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class UserProvider extends ChangeNotifier {
  String? name;
  String? pronouns;
  String? email;
  String? password;
  String? profilePicUrl;
  File? profilePicFile;
  List<TimeOfDay> dailyCheckInTimes = [];
  List<bool>? dailyCheckInEnabled;
  TimeOfDay? quoteReminderTime;
  bool? quoteReminderEnabled;
  List<Contact> contacts = [];
  String? spotifyToken;
  bool dailyStreakEnabled = true;
  TimeOfDay dailyStreakTime = const TimeOfDay(hour: 23, minute: 30);
  bool soundEnabled = true;
  bool musicEnabled = true;
  bool hapticEnabled = true;
  
  Future<void> toggleDailyStreak(bool value) async {
    if (email == null) return;
    dailyStreakEnabled = value;
    await FirebaseFirestore.instance.collection('users').doc(email).update({'dailyStreakEnabled': value});
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
      dailyCheckInTimes = (data['dailyCheckInTimes'] as List)
          .map((time) => TimeOfDay(hour: time['hour'], minute: time['minute']))
          .toList();
      dailyCheckInEnabled = (data['dailyCheckInEnabled'] as List).cast<bool>();
      quoteReminderTime = TimeOfDay(
        hour: data['quoteReminderTime']['hour'],
         minute: data['quoteReminderTime']['minute']);
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
        final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
        await userDoc.set({
          'name': name,
          'pronouns': pronouns,
          'email': email,
          'dailyCheckInTimes': dailyCheckInTimes.map((time) => {
            'hour': time.hour,
            'minute': time.minute,
          }).toList(),
          'dailyCheckInEnabled': dailyCheckInEnabled,
          'quoteReminderTime': quoteReminderTime != null
              ? {
                  'hour': quoteReminderTime!.hour,
                  'minute': quoteReminderTime!.minute,
                }
              : null,
          'quoteReminderEnabled': quoteReminderEnabled,
          'createdAt': FieldValue.serverTimestamp(),
          'dailyStreakEnabled': dailyStreakEnabled,
          'dailyStreakTime': {
            'hour': dailyStreakTime?.hour,
            'minute': dailyStreakTime?.minute,
          },
          'soundEnabled': soundEnabled,
          'musicEnabled': musicEnabled,
          'hapticEnabled': hapticEnabled,
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
    // Optionally store hashed password in Firestore (not recommended to store plain text)
    // await FirebaseFirestore.instance.collection('users').doc(email).update({'password': newPassword});
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
    soundEnabled = true;
    musicEnabled = true;
    hapticEnabled = true;
    notifyListeners();
  }




}