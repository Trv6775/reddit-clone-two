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
    apiKey: 'AIzaSyCiM2N8iqtQrH76Xcr_BebdI0imyxm_dzI',
    appId: '1:151199041179:web:b74185eccd3445dddbe83e',
    messagingSenderId: '151199041179',
    projectId: 'reddit-clone-two',
    authDomain: 'reddit-clone-two.firebaseapp.com',
    storageBucket: 'reddit-clone-two.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAqbrGuifJFkyHLix-wYF4iuEAi3E5XsTA',
    appId: '1:151199041179:android:9920b717e4571bf8dbe83e',
    messagingSenderId: '151199041179',
    projectId: 'reddit-clone-two',
    storageBucket: 'reddit-clone-two.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMKwZnDrH3POwyjIJKgl8pV5xNAKyc-Wk',
    appId: '1:151199041179:ios:c43d5e828d701725dbe83e',
    messagingSenderId: '151199041179',
    projectId: 'reddit-clone-two',
    storageBucket: 'reddit-clone-two.appspot.com',
    iosClientId: '151199041179-bm21i1s5vflav0kahdehel1ogdbon8jv.apps.googleusercontent.com',
    iosBundleId: 'com.trv6775.redditCloneTwo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDMKwZnDrH3POwyjIJKgl8pV5xNAKyc-Wk',
    appId: '1:151199041179:ios:9151ac1aeeb0c545dbe83e',
    messagingSenderId: '151199041179',
    projectId: 'reddit-clone-two',
    storageBucket: 'reddit-clone-two.appspot.com',
    iosClientId: '151199041179-pnfihqqua9495u6u6i5c3o63j2c43fne.apps.googleusercontent.com',
    iosBundleId: 'com.trv6775.redditCloneTwo.RunnerTests',
  );
}
