// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyD8zPToQproNdc48jJ4r1H5_ttZA4lUhSw',
    appId: '1:64934311180:web:c06573fa1139536c3e0529',
    messagingSenderId: '64934311180',
    projectId: 'calendair-8abb9',
    authDomain: 'calendair-8abb9.firebaseapp.com',
    storageBucket: 'calendair-8abb9.appspot.com',
    measurementId: 'G-2B7Q3MHRLV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBqG2Sz_5QpdlL0AG9L_WAC7NVlgI49kZY',
    appId: '1:64934311180:android:c5ff71a5fb888dc93e0529',
    messagingSenderId: '64934311180',
    projectId: 'calendair-8abb9',
    storageBucket: 'calendair-8abb9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCgntl4HGsmzboMCJgKESHVBMis_i7Ua0s',
    appId: '1:64934311180:ios:a4817c0a23bc94213e0529',
    messagingSenderId: '64934311180',
    projectId: 'calendair-8abb9',
    storageBucket: 'calendair-8abb9.appspot.com',
    androidClientId: '64934311180-48rvcrj59po74c0s4kp928m23jfqnlia.apps.googleusercontent.com',
    iosClientId: '64934311180-1q47kk18a8f6pfe2jc2m4jijg5c73pu2.apps.googleusercontent.com',
    iosBundleId: 'com.example.calendair',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCgntl4HGsmzboMCJgKESHVBMis_i7Ua0s',
    appId: '1:64934311180:ios:a4817c0a23bc94213e0529',
    messagingSenderId: '64934311180',
    projectId: 'calendair-8abb9',
    storageBucket: 'calendair-8abb9.appspot.com',
    androidClientId: '64934311180-48rvcrj59po74c0s4kp928m23jfqnlia.apps.googleusercontent.com',
    iosClientId: '64934311180-1q47kk18a8f6pfe2jc2m4jijg5c73pu2.apps.googleusercontent.com',
    iosBundleId: 'com.example.calendair',
  );
}
