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
    apiKey: 'AIzaSyBRajpRUf6VOwDnoHL2j3es3XXmj4-lVRg',
    appId: '1:579973160314:web:269174792718fa5c410ac3',
    messagingSenderId: '579973160314',
    projectId: 'chatz-15cc0',
    authDomain: 'chatz-15cc0.firebaseapp.com',
    storageBucket: 'chatz-15cc0.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAqudP9zcbsxshkU6VKllLPtNZG-BPWmEw',
    appId: '1:579973160314:android:12780f6f08baefb7410ac3',
    messagingSenderId: '579973160314',
    projectId: 'chatz-15cc0',
    storageBucket: 'chatz-15cc0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBHHAAjQhqoUZ8oR28Ol8vjVZFXaf82xho',
    appId: '1:579973160314:ios:10c03d4954ec2a20410ac3',
    messagingSenderId: '579973160314',
    projectId: 'chatz-15cc0',
    storageBucket: 'chatz-15cc0.appspot.com',
    iosBundleId: 'com.example.chatz',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBHHAAjQhqoUZ8oR28Ol8vjVZFXaf82xho',
    appId: '1:579973160314:ios:b7f6690aace88706410ac3',
    messagingSenderId: '579973160314',
    projectId: 'chatz-15cc0',
    storageBucket: 'chatz-15cc0.appspot.com',
    iosBundleId: 'com.example.chatz.RunnerTests',
  );
}
