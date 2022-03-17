import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:orderly/Blocs/login/bloc.dart';
import 'package:orderly/Blocs/login/login_bloc.dart';
import 'package:orderly/Models/model_user.dart';
import 'package:orderly/Models/push_notification.dart';
import 'package:orderly/Screens/Customer/orders/myOrders.dart';
import 'package:orderly/Screens/mainNavigation.dart';
import 'package:orderly/Screens/user/choiceScreen.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/routes.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:http/http.dart' as http;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications', 'description',
    importance: Importance.high, playSound: true);

class PushNotify {
  static GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  static PushNotification notification;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static Future<void> registerNotification(FirebaseMessaging _messaging, BuildContext context) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _messaging = FirebaseMessaging.instance;
    //to set background messaging handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    //to create local NotificationChannel
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );



    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    // FirebaseMessaging.onBackgroundMessage((message) {
    //   // Logger.log("_messaging onBackgroundMessage: $message");
    //   // print('A new onMessageOpenedApp event was published!');
    //   print("Handling a background message: ${message.messageId}");
    //
    //   // Parse the message received
    //   notification = PushNotification(
    //     title: message.notification.title,
    //     body: message.notification?.body,
    //     flag: message.data['flag'],
    //     userType: message.data['user_type'],
    //
    //   );
    //
    //   if (notification != null) {
    //     RemoteNotification notificationRemote = message.notification;
    //     AndroidNotification android = message.notification.android;
    //     if (notificationRemote != null && android != null) {
    //       try {
    //         flutterLocalNotificationsPlugin.show(
    //             0,
    //             notificationRemote.title,
    //             notificationRemote.body,
    //             NotificationDetails(
    //                 android: AndroidNotificationDetails(
    //                     channel.id,
    //                     channel.name,
    //                     channel.description,
    //                     importance: Importance.high,
    //                     color: Colors.blue,
    //                     playSound: true,
    //                     icon: '@mipmap/ic_launcher')),payload:"Notification");
    //         // flutterLocalNotificationsPlugin.show(
    //         //     notification.hashCode,
    //         //     notification.title,
    //         //     notification.body,
    //         //     // ignore: prefer_const_constructors
    //         //     NotificationDetails(android: AndroidNotificationDetails(
    //         //         channel.id, channel.name,
    //         //         channel.description)));
    //       }catch(e) {
    //         print(e);
    //       }
    //     }
    //   }
    //   //used for notification click
    //   initialiseFlutterLocalPlugin(flutterLocalNotificationsPlugin,context,notification);
    //
    //   return;
    // });

    //to provide permissions
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
            'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

        // Parse the message received
        notification = PushNotification(
          title: message.notification.title,
          body: message.notification?.body,
          flag: message.data['flag'],
          userType: message.data['user_type'],
          image: "https://www.fluttercampus.com/img/logo_small.webp"

          // userId: message.data['fbId'],
          // dataTitle: message.data['title'],
          // dataBody: message.data['body'],
        );
        // print("flag:-"+notification.flag);
        // print("userType:-"+notification.userType);

        if (notification != null) {
          RemoteNotification notificationRemote = message.notification;
          AndroidNotification android = message.notification.android;
          if (notificationRemote != null && android != null) {
            try {
              showNotifications(
                  flutterLocalNotificationsPlugin, notificationRemote,context,notification.image);

              // flutterLocalNotificationsPlugin.show(
              //     notification.hashCode,
              //     notification.title,
              //     notification.body,
              //     // ignore: prefer_const_constructors
              //     NotificationDetails(android: AndroidNotificationDetails(
              //         channel.id, channel.name,
              //         channel.description)));
            } catch (e) {
              print(e);
            }
          }
        }
        // //used for notification click
        initialiseFlutterLocalPlugin(
            flutterLocalNotificationsPlugin, context, notification);
      });

      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          // DO YOUR THING HERE
          print('A new onMessageOpenedApp event was published!');
          RemoteNotification remotenotification = message.notification;
          AndroidNotification android = message.notification?.android;
          if (notification != null && android != null) {
            showDialog(
                context: navigatorKey.currentContext,
                builder: (_) {
                  return AlertDialog(
                    title: Text(notification.title),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(remotenotification.body)],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text('Ok'),
                        onPressed: () {
                          // Navigator.of(context).pushNamed(Routes.mainNavi);
                          //imp nvigator key is used as navigation through context didnt worked
                          if (Application.user != null) {
                            if (Application.user.userType ==
                                notification.userType) {
                              navigatorKey.currentState.push(MaterialPageRoute(
                                  builder: (context) => MainNavigation(
                                      userType: notification.userType,
                                      fcmFlagNavigate: notification.flag)));
                            } else {
                              showDialog<dynamic>(
                                  context: navigatorKey.currentContext,
                                  //as used navigator key,so need to use its context if not then only context
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Text(notification.title),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Text(notification.body)
                                            Text(
                                                "Please login with Fleet manager")
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text('Ok'),
                                          onPressed: () {
                                            //imp nvigator key is used as navigation through context didnt worked
                                            navigatorKey.currentState.push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MainNavigation(
                                                            fcmFlagNavigate:
                                                                "logout")));
                                          },
                                        ),
                                      ],
                                    );
                                  });
                              // loginBloc.add(OnLogout());
                            }
                            //i.e logout
                          } else {
                            //to navigate as per userType
                            navigatorKey.currentState.push(MaterialPageRoute(
                                builder: (context) => ChoiceScreen()));
                          }
                        },
                      ),
                    ],
                  );
                });
          }
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
        RemoteNotification remotenotification = message.notification;
        AndroidNotification android = message.notification?.android;
        if (notification != null && android != null) {
          showDialog(
              context: navigatorKey.currentContext,
              builder: (_) {
                return AlertDialog(
                  title: Text(notification.title),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(remotenotification.body)],
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text('Ok'),
                      onPressed: () {
                        // Navigator.of(context).pushNamed(Routes.mainNavi);
                        //imp nvigator key is used as navigation through context didnt worked
                        if (Application.user != null) {
                          if (Application.user.userType ==
                              notification.userType) {
                            navigatorKey.currentState.push(MaterialPageRoute(
                                builder: (context) => MainNavigation(
                                    userType: notification.userType,
                                    fcmFlagNavigate: notification.flag)));
                          } else {
                            showDialog<dynamic>(
                                context: navigatorKey.currentContext,
                                //as used navigator key,so need to use its context if not then only context
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text(notification.title),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Text(notification.body)
                                          Text(
                                              "Please login with Fleet manager")
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          //imp nvigator key is used as navigation through context didnt worked
                                          navigatorKey.currentState.push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MainNavigation(
                                                          fcmFlagNavigate:
                                                              "logout")));
                                        },
                                      ),
                                    ],
                                  );
                                });
                            // loginBloc.add(OnLogout());
                          }
                          //i.e logout
                        } else {
                          //to navigate as per userType
                          navigatorKey.currentState.push(MaterialPageRoute(
                              builder: (context) => ChoiceScreen()));
                        }
                      },
                    ),
                  ],
                );
              });
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  static Future<void> showNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RemoteNotification notificationRemote, BuildContext context, String image) async {
    final ByteArrayAndroidBitmap largeIcon = ByteArrayAndroidBitmap(
        await _getByteArrayFromUrl('https://via.placeholder.com/48x48'));
    final ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(
        await _getByteArrayFromUrl(
           image));

    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(bigPicture,
            // largeIcon: largeIcon,
            // contentTitle: 'overridden <b>big</b> content title',
            // htmlFormatContentTitle: true,
            // summaryText: 'summary <i>text</i>',
            htmlFormatSummaryText: true);

    flutterLocalNotificationsPlugin.show(
        0,
        notificationRemote.title,
        notificationRemote.body,
        NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                styleInformation: bigPictureStyleInformation,
                icon: '@mipmap/ic_launcher')),
        payload: "Notification");

    //used for notification click
    // initialiseFlutterLocalPlugin(
    //     flutterLocalNotificationsPlugin, context, notification);
  }

  static Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  //for background messages
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // showSimpleNotification(
    //   Container(child: Text(message.notification.body.toString())),
    //   position: NotificationPosition.top,
    // );
    var image="https://www.fluttercampus.com/img/logo_small.webp";


    showNotifications(flutterLocalNotificationsPlugin, message.notification,navigatorKey.currentContext,image);
  }

  static Future<void> initialiseFlutterLocalPlugin(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      BuildContext context,
      PushNotification notification) async {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    // var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>MainNavigation(flagOrder: "1")));
        try {
          // Navigator.of(context).pushNamed(Routes.mainNavi);
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>MainNavigation(flagOrder: "1")));
          if (Application.user != null) {
            if (Application.user.userType == notification.userType) {
              navigatorKey.currentState.push(MaterialPageRoute(
                  builder: (context) => MainNavigation(
                      userType: notification.userType,
                      fcmFlagNavigate: notification.flag)));
            } else {
              showDialog<dynamic>(
                  context: navigatorKey.currentContext,
                  //as used navigator key,so need to use its context if not then only context
                  builder: (_) {
                    return AlertDialog(
                      title: Text(notification.title),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(notification.body)
                            Text("Please login with Fleet manager")
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text('Ok'),
                          onPressed: () {
                            //imp nvigator key is used as navigation through context didnt worked
                            navigatorKey.currentState.push(MaterialPageRoute(
                                builder: (context) =>
                                    MainNavigation(fcmFlagNavigate: "logout")));
                          },
                        ),
                      ],
                    );
                  });
              // loginBloc.add(OnLogout());

            }
            //i.e logout
          } else {
            //to navigate as per userType
            navigatorKey.currentState
                .push(MaterialPageRoute(builder: (context) => ChoiceScreen()));
          }
        } catch (e) {
          print(e);
        }
        debugPrint('notification payload: $payload');
      }
    });
  }
}
