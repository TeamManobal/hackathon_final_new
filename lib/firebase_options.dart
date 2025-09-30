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
    apiKey: 'AIzaSyAq3gGhhh4QhoWJf-o07miIAz7gfyJoa_Y',
    appId: '1:101199242862:web:c4e558cb4bb56b2e80687f',
    messagingSenderId: '101199242862',
    projectId: 'athlete-analyzer-sih-2025',
    authDomain: 'athlete-analyzer-sih-2025.firebaseapp.com',
    storageBucket: 'athlete-analyzer-sih-2025.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCLk18Lr1zuNb1Vkx4ZSLA8EEMhDYTzKPU',
    appId: '1:101199242862:android:8c870bc37d04feff80687f',
    messagingSenderId: '101199242862',
    projectId: 'athlete-analyzer-sih-2025',
    storageBucket: 'athlete-analyzer-sih-2025.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAefwZzpCjLp1MPnTe2qsEQml7W9GdZfzE',
    appId: '1:101199242862:ios:2f4e49b01286df2a80687f',
    messagingSenderId: '101199242862',
    projectId: 'athlete-analyzer-sih-2025',
    storageBucket: 'athlete-analyzer-sih-2025.firebasestorage.app',
    iosBundleId: 'com.example.hackathonFinal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAefwZzpCjLp1MPnTe2qsEQml7W9GdZfzE',
    appId: '1:101199242862:ios:2f4e49b01286df2a80687f',
    messagingSenderId: '101199242862',
    projectId: 'athlete-analyzer-sih-2025',
    storageBucket: 'athlete-analyzer-sih-2025.firebasestorage.app',
    iosBundleId: 'com.example.hackathonFinal',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAq3gGhhh4QhoWJf-o07miIAz7gfyJoa_Y',
    appId: '1:101199242862:web:2b1ccb8ee48a9a9680687f',
    messagingSenderId: '101199242862',
    projectId: 'athlete-analyzer-sih-2025',
    authDomain: 'athlete-analyzer-sih-2025.firebaseapp.com',
    storageBucket: 'athlete-analyzer-sih-2025.firebasestorage.app',
  );
}
