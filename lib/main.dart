// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:orderly/Configs/language.dart';
// import 'package:orderly/Configs/theme.dart';
// import 'package:orderly/Screens/Customer/orders/myOrders.dart';
// import 'package:orderly/Screens/mainNavigation.dart';
// import 'package:orderly/Utils/application.dart';
// import 'package:orderly/Utils/routes.dart';
// import 'package:orderly/Utils/translate.dart';
// import 'package:orderly/app.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// const AndroidNotificationChannel channel=AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     'description',
//     importance: Importance.high,
//     playSound: true);
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('A bg message just showed up :  ${message.messageId}');
// }
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   Bloc.observer = BlocObserver();
//   Application.preferences = await SharedPreferences.getInstance();
//
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//       AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//
//
//
//   runApp(MyApp());
//   // runApp(EasyLocalization(
//   //       path: 'assets/locale',
//   //       startLocale: AppLanguage.defaultLanguage,
//   //   supportedLocales: AppLanguage.supportLanguage,
//   //   child:MyApp()));
// }
//
// class MyApp extends StatefulWidget{
//   _MyAppState createState()=>_MyAppState();
// }
//
// class _MyAppState extends State<MyApp>{
//   // This widget is the root of your application.
//   final route = Routes();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     initialiseFlutterLocalPlugin(flutterLocalNotificationsPlugin, context);
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification notification = message.notification;
//       AndroidNotification android = message.notification?.android;
//       if (notification != null && android != null) {
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             // ignore: prefer_const_constructors
//             NotificationDetails(android: AndroidNotificationDetails(channel.id, channel.name,
//                 channel.description)),payload: "Notification");
//       }
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('A new onMessageOpenedApp event was published!');
//       RemoteNotification notification = message.notification;
//       AndroidNotification android = message.notification?.android;
//       if (notification != null && android != null) {
//         showDialog(
//             context: context,
//             builder: (_) {
//               return AlertDialog(
//                 title: Text(notification.title),
//                 content: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [Text(notification.body)],
//                   ),
//                 ),
//               );
//             });
//       }
//     });
//   }
//   static Future<void> initialiseFlutterLocalPlugin(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, BuildContext context) async{
//
//     var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initializationSettingsIOS = new IOSInitializationSettings();
//     // var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
//     final InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: (String payload) async {
//           if (payload != null) {
//             try {
//               Navigator.push(context, MaterialPageRoute(
//                   builder: (context) => MainNavigation(flagOrder: "0")));
//             }catch(e){
//               print(e);
//               // error:-Navigator operation requested with a context that does not include a Navigator.
//               // The context used to push or pop routes from the
//             }
//             // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyOrders()));
//             // return App();
//             // showDialog(
//             //   context: context,
//             //   builder: (context) => AlertDialog(
//             //     content: ListTile(
//             //       title: Text("notification.title"),
//             //       subtitle: Text("notification.body"),
//             //     ),
//             //     actions: <Widget>[
//             //       FlatButton(
//             //         child: Text('Ok'),
//             //         onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (context)=>MainNavigation(flagOrder: "1")))
//             //         ,
//             //       ),
//             //     ],
//             //   ),
//             // );
//             debugPrint('notification payload: $payload');
//           }
//
//         });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       // MaterialApp(
//       // debugShowCheckedModeBanner: false,
//       // theme: AppTheme.lightTheme,
//       // darkTheme: AppTheme.darkTheme,
//       // locale: AppLanguage.defaultLanguage,
//       //
//       // localizationsDelegates: [
//       //   Translate.delegate,
//       //   GlobalMaterialLocalizations.delegate,
//       //   GlobalWidgetsLocalizations.delegate,
//       // ],
//       // supportedLocales: AppLanguage.supportLanguage,
//       //
//       // onGenerateRoute: route.generateRoute,
//       // title: 'Flutter Demo',
//       // theme: ThemeData(
//       //   primarySwatch: Colors.blue,
//       // ),
//       // home:
//       App();
//     // );
//   }
// }
//
// class MyAppTest extends StatelessWidget {
//   MyAppTest({Key key}) : super(key: key);
//   final route = Routes();
//
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.lightTheme,
//       darkTheme: AppTheme.darkTheme,
//       locale: AppLanguage.defaultLanguage,
//
//       localizationsDelegates: [
//         Translate.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//       ],
//       supportedLocales: AppLanguage.supportLanguage,
//
//       onGenerateRoute: route.generateRoute,
//       title: 'Flutter Demo',
//       // theme: ThemeData(
//       //   primarySwatch: Colors.blue,
//       // ),
//       home: App(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key key, @required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification notification = message.notification;
//       AndroidNotification android = message.notification?.android;
//       if (notification != null && android != null) {
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             // ignore: prefer_const_constructors
//             NotificationDetails(android: AndroidNotificationDetails(channel.id, channel.name,
//                 channel.description)),payload: "Notification");
//       }
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('A new onMessageOpenedApp event was published!');
//       RemoteNotification notification = message.notification;
//       AndroidNotification android = message.notification?.android;
//       if (notification != null && android != null) {
//         showDialog(
//             context: context,
//             builder: (_) {
//               return AlertDialog(
//                 title: Text(notification.title),
//                 content: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [Text(notification.body)],
//                   ),
//                 ),
//               );
//             });
//       }
//     });
//   }
//
//   void showNotification() {
//     setState(() {
//       _counter++;
//     });
//     flutterLocalNotificationsPlugin.show(
//         0,
//         "Testing $_counter",
//         "How you doing?",
//         NotificationDetails(
//             android: AndroidNotificationDetails(channel.id, channel.name,
//                 channel.description,
//                 importance: Importance.high,
//                 color: Colors.blue,
//                 playSound: true,
//                 icon: '@mipmap/ic_launcher')));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: showNotification,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }


import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/preferences.dart';
import 'package:orderly/Utils/pushNotify.dart';
import 'package:orderly/Utils/util_preferences.dart';
import 'package:orderly/app.dart';
import 'package:orderly/app_bloc.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Configs/language.dart';
import 'Configs/theme.dart';
import 'Utils/routes.dart';
import 'Utils/translate.dart';

// class AppBlocObserver extends BlocObserver {
//   @override
//   void on(Bloc bloc, Object event) {
//     UtilLogger.log('BLOC EVENT', event);
//     super.onEvent(bloc, event);
//   }
//
//   @override
//   void onError(Cubit cubit, Object error, StackTrace stackTrace) {
//     UtilLogger.log('BLOC ERROR', error);
//     super.onError(cubit, error, stackTrace);
//   }
//
//   @override
//   void onTransition(Bloc bloc, Transition transition) {
//     UtilLogger.log('BLOC TRANSITION', transition);
//     super.onTransition(bloc, transition);
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Bloc.observer = BlocObserver();
  // SharedPreferences.setMockInitialValues({});

  Application.preferences = await SharedPreferences.getInstance();
  final route = Routes();

  runZonedGuarded(() {
    runApp(
        // MaterialApp(
            // navigatorKey: PushNotify.navigatorKey,

        // debugShowCheckedModeBanner: false,
        //         theme: AppTheme.lightTheme,
        //         darkTheme: AppTheme.darkTheme,
        //         locale: AppLanguage.defaultLanguage,
        //
        //         localizationsDelegates: [
        //           Translate.delegate,
        //           // EasyLocalization.of(context).delegate,
        //
        //           GlobalMaterialLocalizations.delegate,
        //           GlobalWidgetsLocalizations.delegate,
        //         ],
        //         // localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        //         //   GlobalMaterialLocalizations.delegate,
        //         //   GlobalWidgetsLocalizations.delegate,
        //         //   EasyLocalization.of(context).delegate,
        //         // ],
        //         supportedLocales: AppLanguage.supportLanguage,
        //         // supportedLocales: EasyLocalization.of(context).supportedLocales,
        //         // locale: EasyLocalization.of(context).locale,
        //
        //         onGenerateRoute: route.generateRoute,
        // home:
        App());
  }, FirebaseCrashlytics.instance.recordError);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xffDF5F00),
  ));
}

