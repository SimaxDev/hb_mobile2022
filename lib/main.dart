import 'dart:async';
import 'dart:io';
import 'package:async/async.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/firebase_options.dart';
import 'package:hb_mobile2021/local_notification_service.dart';
import 'package:hb_mobile2021/restart.dart';
import 'package:hb_mobile2021/ui/Login/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:resize/resize.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    // 'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}
Future<void> backgroundHandler(RemoteMessage message) async{
  print(message.data.toString());
  print(message.notification!.title);
  await Firebase.initializeApp();
}
const debug = true;
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: debug,ignoreSsl: true);
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
  await Firebase.initializeApp();
  //await Firebase.initializeApp(options: DefaultFirebaseOptions
    //  .currentPlatform,);
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  SharedPreferences sharedStorage = await SharedPreferences.getInstance();
  if(sharedStorage.containsKey("expires_in")){
    var expireIn = sharedStorage.getString("expires_in");
    DateTime now = DateTime.now();
    var checkTimetoken = DateTime.parse(expireIn!).compareTo(now);
    if(checkTimetoken > 0){
      isLogin = true;
    }else{
      isLogin = false;
    }
  }else{
    isLogin = false;
  }
  _initializeTimer();


  runApp(MyApp());

}
 Timer? _timer;
void _initializeTimer() {
  _timer = Timer.periodic(const Duration(minutes:5), (_) {
    rester().logOutALL();
    _timer?.cancel();
  });

}
void _handleUserInteraction([_]) {
  _timer?.cancel();
  _initializeTimer();

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Resize(
        builder: () {
          return Listener(onPointerDown:_handleUserInteraction ,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home:GestureDetector(
                // onTap: _handleUserInteraction,
                // onPanDown: _handleUserInteraction,
                // onScaleStart: _handleUserInteraction,
                child: Notification(),
                // builder: (BuildContext context, Widget child) {
                //   final MediaQueryData data = MediaQuery.of(context);
                //   return MediaQuery(
                //     data: data.copyWith(
                //         textScaleFactor: data.textScaleFactor > 2.0 ? 2.0 : data.textScaleFactor),
                //     child: FlutterEasyLoading(child: child),
                //   )  ;
                // },
              ),
              builder: EasyLoading.init(),
            ),
          );
        }

    )
     ;
  }
}


// Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
//   if (message.containsKey('data')) {
//     final dynamic data = message['data'];
//   }
//   if (message.containsKey('notification')) {
//     final dynamic notification = message['notification'];
//   }
// }

class Notification extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late SharedPreferences sharedStorage;
  final _keymain = GlobalKey<ScaffoldState>();
  // FirebaseMessaging firebaseMessaging;
  late Timer _timer;


  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(seconds:10), (_) {
      print(_timer);
      Navigator.of
        (context).pop();
      _timer?.cancel();
      print('ket thuc');
    });

  }




  // @override
  // void initState() {
  //   // _initializeTimer();
  //   // pushNotification();
  //   // flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  //   // AndroidInitializationSettings initializationSettingsAndroid =
  //   //     AndroidInitializationSettings('@mipmap/ic_launcher');
  //   // final IOSInitializationSettings initializationSettingsIOS =
  //   //     IOSInitializationSettings(
  //   //         requestAlertPermission: false,
  //   //         requestBadgePermission: false,
  //   //         requestSoundPermission: false,
  //   //         onDidReceiveLocalNotification:
  //   //             (int id, String title, String body, String payload) async {
  //   //           // didReceiveLocalNotificationSubject.add(ReceivedNotification(
  //   //           //     id: id, title: title, body: body, payload: payload));
  //   //         });
  //   // var initSetttings = new InitializationSettings(
  //   //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  //   // flutterLocalNotificationsPlugin.initialize(initSetttings,
  //   //     onSelectNotification: onSelectNotification);
  //   // firebaseMessaging.getToken().then((String token) {
  //   //   assert(token != null);
  //   //   tokenfirebase = token;
  //   // });
  //   super.initState();
  // }
  @override
  void initState() {
    super.initState();
    LocalNotificationService.initialize(context);
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message != null){
        final routeFromMessage = message.data["route"];
      }
    });

    ///foreground
    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification != null){
        print(message.notification?.body);
        print(message.notification?.title);
      }

      LocalNotificationService.display(message);
    });
    ///open app
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];

      Navigator.of(context).pushNamed(routeFromMessage);
    });

    FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    if(Platform.isIOS){

      FirebaseMessaging.instance.getAPNSToken().then((value){
        print("token key =" + value.toString());
      tokenDevice = value.toString();
      });

      //
      // FirebaseMessaging.instance.getAPNSToken().then((value){
      //   print("token key =" + value.toString());
      // tokenDevice = value.toString();
      // });
    }else{
      FirebaseMessaging.instance.getToken().then((value){
        print("token key =" + value.toString());
        tokenDevice = value.toString();
      });
    }


    if (Platform.isIOS) {
      FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

    }
  }

  void showNotification() {
   int _counter = 0;
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing $_counter",
        "How you doin ?",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                // channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }




  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _keymain,
        body: SplashWidget() ,

      ),
      // builder: (BuildContext context, Widget child) {
      //   return FlutterEasyLoading(child: child);
      // },
    );

    // return  Provider(
    //   create: (_) => TaskDatabase(),
    //   child: GestureDetector(
    //   onTap: () {
    // FocusScopeNode currentFocus = FocusScope.of(context);
    // },
    // child:GetMaterialApp(
    //     home: Scaffold(
    //       key: _keymain,
    //       body: SplashWidget() ,
    //
    //     ),
    //     builder: (BuildContext context, Widget child) {
    //       return FlutterEasyLoading(child: child);
    //     },
    //   ),)
    // );
  }

}
