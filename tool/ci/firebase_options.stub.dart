// CI / example stub — not a real Firebase project.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Placeholder [FirebaseOptions] so `flutter analyze` / tests work without secrets.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'ci-stub',
    appId: '1:0:web:ci',
    messagingSenderId: '0',
    projectId: 'ci-stub',
    authDomain: 'ci-stub.firebaseapp.com',
    storageBucket: 'ci-stub.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'ci-stub',
    appId: '1:0:android:ci',
    messagingSenderId: '0',
    projectId: 'ci-stub',
    storageBucket: 'ci-stub.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'ci-stub',
    appId: '1:0:ios:ci',
    messagingSenderId: '0',
    projectId: 'ci-stub',
    storageBucket: 'ci-stub.appspot.com',
    iosBundleId: 'com.example.f1PetProject',
  );
}
