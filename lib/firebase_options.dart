import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAimBuguDrJahLim7IgCN8Zq1rYMczYgzA",
    authDomain: "mindsync-4f867.firebaseapp.com",
    projectId: "mindsync-4f867",
    storageBucket: "mindsync-4f867.appspot.com",
    messagingSenderId: "893227708048",
    appId: "1:893227708048:web:3152c2e60b9d151d4f3215",
    measurementId: "G-879MEMF53N",
  );
} 