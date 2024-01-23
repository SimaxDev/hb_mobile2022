// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AAAAFrff16o:APA91bG2S0NxabuVJ2I6Wuv8PlvOu1wCVFIVmzCOt35AjksJILet_DjAYtWD8foBrmLvZmftTbHLWtTcIO92lZoVXgTZq9cIjJ6DVZILFdHVNzE5izJ_mPmbn2yXE_zDmtM1LJKbTGyf',
    appId: '1:97574180778:android:29f230a5351b2c4286fdd3',
    messagingSenderId: '97574180778',
    projectId: 'VBDH Hoà Bình',
    storageBucket: 'com.hoabinh.gov.hb_mobile2021',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: '7V4UDH78JC',
    appId: '1:97574180778:ios:a439cdabb82eda1486fdd3',
    messagingSenderId: '97574180778',
    projectId: 'VBDH Hoà Bình',
    storageBucket: 'com.hoabinh.jsc.gov.vn',
    androidClientId: '302804362662-972dg6cc4agcc3g5213gfvr6qvfs9089.apps.googleusercontent.com',
    iosClientId: '302804362662-di14a1am884vf9n9st9rn2m8e9hktv7m.apps.googleusercontent.com',
    iosBundleId: 'n',
  );
}