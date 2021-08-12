import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/preferences.dart';
import 'package:orderly/Utils/util_preferences.dart';
import 'package:orderly/app.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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


  runZonedGuarded(() {
    runApp((App()));
  }, FirebaseCrashlytics.instance.recordError);
  // runApp(NotifyDemo());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xffDF5F00),
  ));
}

// class MyApp extends StatelessWidget{
//   // final CartModel model;
//   // MyApp({Key? key, required this.model}) : super(key: key);
//
//   final route = Routes();
//
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//    return
//      // ScopedModel<CartModel>(
//      //   model: model,
//      //   child:
//        MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: AppTheme.lightTheme,
//         darkTheme: AppTheme.darkTheme,
//         locale: AppLanguage.defaultLanguage,
//
//         localizationsDelegates: [
//           Translate.delegate,
//           GlobalMaterialLocalizations.delegate,
//           GlobalWidgetsLocalizations.delegate,
//         ],
//         supportedLocales: AppLanguage.supportLanguage,
//
//         onGenerateRoute: route.generateRoute,
//         home: App()
//
//     );
//      // );
//
//   }
//
// }





