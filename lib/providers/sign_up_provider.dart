import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignUpProvider extends ChangeNotifier {
  String? name;
  String? pronouns;
  String? email;
  String? password;
  List<TimeOfDay> dailyCheckInTimes = [];
  List<bool> dailyCheckInEnabled = [false, false, false, false];
  TimeOfDay? quoteReminderTime;
  bool quoteReminderEnabled = false;
  List<Contact> contacts = [];
  String? spotifyToken;

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

  Future<void> createUser() async {
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
    } catch (e) {
      debugPrint('Error creating user: $e');
      rethrow;
    }
  }
}