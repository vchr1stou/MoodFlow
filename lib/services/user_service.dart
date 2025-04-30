import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user's data
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.email).get();
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Stream of current user's data
  Stream<DocumentSnapshot> getCurrentUserStream() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore.collection('users').doc(user.email).snapshots();
    }
    throw Exception('No user logged in');
  }
}
