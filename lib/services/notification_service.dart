import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> init() async {
    print('Initializing NotificationService...');
    
    // Request permission for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    
    print('User granted permission: ${settings.authorizationStatus}');

    // Get FCM token
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Save token to Firestore
    if (token != null) {
      await _saveTokenToFirestore(token);
    }

    // Handle token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print('FCM Token refreshed: $newToken');
      _saveTokenToFirestore(newToken);
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    // Handle notification taps
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message tapped: ${message.notification?.title}');
    });

    // Check for initial message (app opened from terminated state)
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print('App opened from terminated state with notification: ${initialMessage.notification?.title}');
    }
  }

  Future<void> _saveTokenToFirestore(String token) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.email).update({
          'fcmToken': token,
          'lastTokenUpdate': FieldValue.serverTimestamp(),
        });
        print('FCM Token saved to Firestore');
      }
    } catch (e) {
      print('Error saving FCM token to Firestore: $e');
    }
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    print('Scheduling notification: $title at ${time.hour}:${time.minute}');
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get the user's FCM token
        final userDoc = await _firestore.collection('users').doc(user.email).get();
        final userData = userDoc.data();
        final fcmToken = userData?['fcmToken'];

        if (fcmToken != null) {
          // Create a notification document in Firestore
          await _firestore.collection('users').doc(user.email).collection('notifications').add({
            'id': id,
            'title': title,
            'body': body,
            'scheduledTime': DateTime.now().add(Duration(hours: time.hour, minutes: time.minute)),
            'fcmToken': fcmToken,
            'status': 'pending',
            'createdAt': FieldValue.serverTimestamp(),
          });
          print('Notification scheduled in Firestore');
        } else {
          print('No FCM token found for user');
        }
      }
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  Future<void> cancelNotification(int id) async {
    print('Cancelling notification with id: $id');
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Find and delete the notification from Firestore
        final notifications = await _firestore
            .collection('users')
            .doc(user.email)
            .collection('notifications')
            .where('id', isEqualTo: id)
            .get();
        
        for (var doc in notifications.docs) {
          await doc.reference.delete();
        }
        print('Notification cancelled in Firestore');
      }
    } catch (e) {
      print('Error cancelling notification: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    print('Cancelling all notifications');
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Delete all notifications from Firestore
        final notifications = await _firestore
            .collection('users')
            .doc(user.email)
            .collection('notifications')
            .get();
        
        for (var doc in notifications.docs) {
          await doc.reference.delete();
        }
        print('All notifications cancelled in Firestore');
      }
    } catch (e) {
      print('Error cancelling all notifications: $e');
    }
  }

  Future<String?> getToken() async {
    String? token = await _firebaseMessaging.getToken();
    print('Current FCM Token: $token');
    return token;
  }
}

// This needs to be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling background message: ${message.messageId}');
  print('Background message data: ${message.data}');
  if (message.notification != null) {
    print('Background message notification: ${message.notification}');
  }
} 