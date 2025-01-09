// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCvBcJH6shCnd5fEUDDQ2MIXg4v22t1UrQ',
    appId: '1:219580675648:web:0544e5cb0b664092c9d1a5',
    messagingSenderId: '219580675648',
    projectId: 'pulse-admin-3cc3d',
    authDomain: 'pulse-admin-3cc3d.firebaseapp.com',
    storageBucket: 'pulse-admin-3cc3d.firebasestorage.app',
    measurementId: 'G-BDY0H9FF3H',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDe-d_dj6MpXaQo4cICODuAN-YReRJbC1I',
    appId: '1:219580675648:android:71d6573298aa6c16c9d1a5',
    messagingSenderId: '219580675648',
    projectId: 'pulse-admin-3cc3d',
    storageBucket: 'pulse-admin-3cc3d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBiRS0lIeod6xPKlNQPzounQS_dQyqN2vY',
    appId: '1:219580675648:ios:61fc382a23ca4f1bc9d1a5',
    messagingSenderId: '219580675648',
    projectId: 'pulse-admin-3cc3d',
    storageBucket: 'pulse-admin-3cc3d.firebasestorage.app',
    iosBundleId: 'com.example.crisisSupport',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBiRS0lIeod6xPKlNQPzounQS_dQyqN2vY',
    appId: '1:219580675648:ios:61fc382a23ca4f1bc9d1a5',
    messagingSenderId: '219580675648',
    projectId: 'pulse-admin-3cc3d',
    storageBucket: 'pulse-admin-3cc3d.firebasestorage.app',
    iosBundleId: 'com.example.crisisSupport',
  );
}
