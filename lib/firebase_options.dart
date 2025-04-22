import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAnGJIjGIz26juyRWRdyeDqZ4m93r33Bso',
    appId: '1:463986263013:web:ec99cbe3405452cd5ba50c',
    messagingSenderId: '463986263013',
    projectId: 'moodflow-1390a',
    authDomain: 'moodflow-1390a.firebaseapp.com',
    storageBucket: 'moodflow-1390a.firebasestorage.app',
    measurementId: 'G-2G2WMHW3V5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDKu2gPXiTPo__N98mveJUzQ5wBAAsRp-k',
    appId: '1:463986263013:android:273cf61d916ce4b55ba50c',
    messagingSenderId: '463986263013',
    projectId: 'moodflow-1390a',
    storageBucket: 'moodflow-1390a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDohu3J9jw0lUyUswNP3PxiKzXKJJQJvNk',
    appId: '1:463986263013:ios:8b7e32a82b98ea1e5ba50c',
    messagingSenderId: '463986263013',
    projectId: 'moodflow-1390a',
    storageBucket: 'moodflow-1390a.firebasestorage.app',
    iosBundleId: 'com.MoodFlow',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDohu3J9jw0lUyUswNP3PxiKzXKJJQJvNk',
    appId: '1:463986263013:ios:7ed1f08e2c95c0925ba50c',
    messagingSenderId: '463986263013',
    projectId: 'moodflow-1390a',
    storageBucket: 'moodflow-1390a.firebasestorage.app',
    iosBundleId: 'com.example.newFlutterApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAnGJIjGIz26juyRWRdyeDqZ4m93r33Bso',
    appId: '1:463986263013:web:54eced169e444efa5ba50c',
    messagingSenderId: '463986263013',
    projectId: 'moodflow-1390a',
    authDomain: 'moodflow-1390a.firebaseapp.com',
    storageBucket: 'moodflow-1390a.firebasestorage.app',
    measurementId: 'G-NW7S1JJ87R',
  );

}