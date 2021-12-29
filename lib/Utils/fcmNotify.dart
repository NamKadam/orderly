import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:orderly/Models/push_notification.dart';
import 'package:orderly/Screens/mainNavigation.dart';
import 'package:overlay_support/overlay_support.dart';


class FcmNotify{
  static var flutterLocalNotificationsPlugin;

  static Future<void> registerNotification(FirebaseMessaging _messaging,BuildContext context) async {
    // await Firebase.initializeApp();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    _messaging = FirebaseMessaging.instance;
    initialiseFlutterLocalPlugin(flutterLocalNotificationsPlugin,context);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {

        print('Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        if (notification != null) {
          // For displaying the notification as an overlay
          // showSimpleNotification(
          //   Text(notification.title),
          //   // leading: NotificationBadge(totalNotifications: _totalNotifications),
          //   subtitle: Text(notification.body),
          //   background: Colors.cyan.shade700,
          //   duration: Duration(seconds: 10),
          // );
          // Future.delayed(Duration(seconds: 5), () {
            // showDialog(
            //   context: context,
            //   builder: (context) => AlertDialog(
            //     content:
            //     MaterialApp(
            //         home:ListTile(
            //       title: Text(notification.title),
            //       subtitle: Text(notification.body),
            //     )),
            //     actions: <Widget>[
            //       FlatButton(
            //         child: Text('Ok'),
            //         onPressed: () =>  Navigator.push(context, MaterialPageRoute(builder: (context)=>MainNavigation(flagOrder: "1"))),
            //       ),
            //     ],
            //   ),
            // );

            // _showMyDialog(context,notification);
            _demoNotification(notification.title,notification.body);

          // });


        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  static Future<void> _demoNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.max,
        playSound: true,
        // sound: 'sound',
        showProgress: true,
        priority: Priority.high,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    print(androidPlatformChannelSpecifics);
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'test');
  }
  static Future<void> initialiseFlutterLocalPlugin(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, BuildContext context) async{
    // final NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    // String initialRoute = HomePage.routeName;
    // if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    //   selectedNotificationPayload = notificationAppLaunchDetails!.payload;
    //   initialRoute = SecondPage.routeName;
    // }

    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    // var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    // flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
          if (payload != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainNavigation(flagOrder: "1")));
            debugPrint('notification payload: $payload');
          }

        });
  }

  static Future<void> _showMyDialog(BuildContext context, PushNotification notification) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // Text('This is a demo alert dialog.'),
                Text(notification.title),
                Text(notification.body),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
    showSimpleNotification(
      Container(child: Text(message.notification.body.toString())),
      position: NotificationPosition.top,
    );
  }

  // static Future<void> fcmConfigure(BuildContext context, FirebaseMessaging _fcm, String loginUserId, String loginUserName, String phone, String userEmail) async {
  //   // final FirebaseMessaging _fcm = FirebaseMessaging();
  //   NotificationSettings? settings;
  //   if (Platform.isIOS) {
  //
  //     settings = await _fcm.requestPermission(
  //       alert: true,
  //       badge: true,
  //       provisional: false,
  //       sound: true,
  //     );
  //     if (settings!.authorizationStatus == AuthorizationStatus.authorized) {
  //       print('User granted permission');
  //       onMessageReceived();
  //     }else{
  //       print('User declined or has not accepted permission');
  //
  //     }
  //   }else{
  //     onMessageReceived();
  //
  //   }
  //
  //   _fcm.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print('onMessage: $message');
  //
  //       final String notiMessage = _parseNotiMessage(message);
  //
  //       // _onSelectNotification(context, notiMessage);
  //       Utils.takeDataFromNoti(context, message, loginUserId,loginUserName,phone,userEmail);
  //
  //       PsSharedPreferences.instance.replaceNotiMessage(
  //         notiMessage,
  //       );
  //     },
  //     onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print('onLaunch: $message');
  //
  //       final String notiMessage = _parseNotiMessage(message);
  //
  //       // _onSelectNotification(context, notiMessage);
  //       Utils.takeDataFromNoti(context, message, loginUserId,loginUserName,phone,userEmail);
  //
  //       PsSharedPreferences.instance.replaceNotiMessage(
  //         notiMessage,
  //       );
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print('onResume: $message');
  //
  //       final String notiMessage = _parseNotiMessage(message);
  //
  //       // _onSelectNotification(context, notiMessage);
  //       Utils.takeDataFromNoti(context, message, loginUserId,loginUserName,phone,userEmail);
  //
  //       PsSharedPreferences.instance.replaceNotiMessage(
  //         notiMessage,
  //       );
  //     },
  //   );
  // }

  // static void onMessageReceived(){
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     // Parse the message received
  //     // PushNotification notification = PushNotification(
  //     //   title: message.notification?.title,
  //     //   body: message.notification?.body,
  //     // );
  //     if (_notificationInfo != null) {
  //       // For displaying the notification as an overlay
  //       showSimpleNotification(
  //         Text(_notificationInfo!.title!),
  //         leading: NotificationBadge(totalNotifications: _totalNotifications),
  //         subtitle: Text(_notificationInfo!.body!),
  //         background: Colors.cyan.shade700,
  //         duration: Duration(seconds: 2),
  //       );
  //     }
  //
  //
  //   });
  // }

}