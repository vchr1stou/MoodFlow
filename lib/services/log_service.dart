import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:contacts_service/contacts_service.dart';

class LogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveLog({
    required String mood,
    required DateTime timestamp,
    required String subcollectionName,
    Set<String>? toggledIcons,
    List<Contact>? contacts,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      if (user.email == null) {
        throw Exception('User email is null');
      }

      print('Current user email: ${user.email}');
      print('Attempting to save log to path: users/${user.email}/logs/$subcollectionName');

      // Create a new log document in the user's logs subcollection with the specified name
      await _firestore
          .collection('users')
          .doc(user.email)
          .collection('logs')
          .doc(subcollectionName)
          .set({
        'mood': mood,
        'timestamp': timestamp,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // If we have toggled icons, save them in a whats_happening subcollection
      if (toggledIcons != null && toggledIcons.isNotEmpty) {
        print('Saving toggled icons to whats_happening subcollection');
        await _firestore
            .collection('users')
            .doc(user.email)
            .collection('logs')
            .doc(subcollectionName)
            .collection('whats_happening')
            .doc('icons')
            .set({
          'toggledIcons': toggledIcons.toList(),
          'timestamp': timestamp,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // If we have contacts, save them in a contacts subcollection
      if (contacts != null && contacts.isNotEmpty) {
        print('Saving contacts to contacts subcollection');
        final List<Map<String, dynamic>> contactData = contacts.map((contact) {
          return {
            'displayName': contact.displayName ?? '',
            'phones': contact.phones?.map((phone) => phone.value).toList() ?? [],
            'emails': contact.emails?.map((email) => email.value).toList() ?? [],
          };
        }).toList();

        await _firestore
            .collection('users')
            .doc(user.email)
            .collection('logs')
            .doc(subcollectionName)
            .collection('contacts')
            .doc('list')
            .set({
          'contacts': contactData,
          'timestamp': timestamp,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      
      print('Log saved successfully');
    } on FirebaseException catch (e) {
      print('Firebase error saving log: ${e.code} - ${e.message}');
      print('Error details: ${e.toString()}');
      rethrow;
    } catch (e) {
      print('Error saving log: $e');
      rethrow;
    }
  }
} 