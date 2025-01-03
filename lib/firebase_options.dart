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
    apiKey: 'AIzaSyCEu-Pkc93oc8AmbLYAFOgDIhJJiv9IPQo',
    appId: '1:778910484818:web:53fa919168b6d7d55f128b',
    messagingSenderId: '778910484818',
    projectId: 'rdp-todolist-e25e0',
    authDomain: 'rdp-todolist-e25e0.firebaseapp.com',
    storageBucket: 'rdp-todolist-e25e0.firebasestorage.app',
    measurementId: 'G-V1YLSX1VJG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBaKNkC_f_WqJn7uR_lXDjzcPP8i4o8bRE',
    appId: '1:778910484818:android:1c1eff94f8bd9c645f128b',
    messagingSenderId: '778910484818',
    projectId: 'rdp-todolist-e25e0',
    storageBucket: 'rdp-todolist-e25e0.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDebVx0i1zbKdcIxny287VQOTiMa_1YKLU',
    appId: '1:778910484818:ios:bd9cc2c21efb7c5a5f128b',
    messagingSenderId: '778910484818',
    projectId: 'rdp-todolist-e25e0',
    storageBucket: 'rdp-todolist-e25e0.firebasestorage.app',
    iosBundleId: 'com.example.rdpTodolist',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDebVx0i1zbKdcIxny287VQOTiMa_1YKLU',
    appId: '1:778910484818:ios:bd9cc2c21efb7c5a5f128b',
    messagingSenderId: '778910484818',
    projectId: 'rdp-todolist-e25e0',
    storageBucket: 'rdp-todolist-e25e0.firebasestorage.app',
    iosBundleId: 'com.example.rdpTodolist',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCEu-Pkc93oc8AmbLYAFOgDIhJJiv9IPQo',
    appId: '1:778910484818:web:3e4ddaac8ae9e3d55f128b',
    messagingSenderId: '778910484818',
    projectId: 'rdp-todolist-e25e0',
    authDomain: 'rdp-todolist-e25e0.firebaseapp.com',
    storageBucket: 'rdp-todolist-e25e0.firebasestorage.app',
    measurementId: 'G-S4K8LHC0NC',
  );
}
