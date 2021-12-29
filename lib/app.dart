import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:orderly/Blocs/authentication/authentication_bloc.dart';
import 'package:orderly/Blocs/authentication/authentication_state.dart';
import 'package:orderly/Configs/language.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Screens/mainNavigation.dart';
import 'package:orderly/Screens/splash_screen.dart';
import 'package:orderly/Screens/user/choiceScreen.dart';
import 'package:orderly/Utils/application.dart';

import 'package:orderly/Utils/authentication.dart';
import 'package:orderly/Utils/pushNotify.dart';
import 'package:orderly/Utils/routes.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Utils/util_preferences.dart';
import 'package:orderly/app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';


import 'package:shared_preferences/shared_preferences.dart';

import 'Utils/fcmNotify.dart';



//Toggle this to cause an async error to be thrown during initialization
// and to test that runZonedGuarded() catches the error
const _kShouldTestAsyncErrorOnInit = false;
// Toggle this for testing Crashlytics in your app locally.
const _kTestingCrashlytics = true;

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}



class _AppState extends State<App> {
  final route = Routes();
  Future<void> _initializeFlutterFireFuture;

  var locator;


  @override
  void dispose() {
    AppBloc.dispose();
    super.dispose();
  }

  // Define an async function to initialize FlutterFire
  Future<void> _initializeFlutterFire() async {
    // Wait for Firebase to initialize

    if (_kTestingCrashlytics) {
      // Force enable crashlytics collection enabled if we're testing it.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      // Else only enable it in non-debug builds.
      // You could additionally extend this to allow users to opt-in.
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(false);
    }
  }

  @override
  void initState() {
    super.initState();
    // Authentication.initializeFirebase(context: context);
    // locator.registerLazySingleton(() => PushNotify());

    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    getToken();
    PushNotify.registerNotification(_fcm,context);
    //used to force for crash
    // FirebaseCrashlytics.instance.crash();
  }

  getToken() async{
    String token=await FirebaseMessaging.instance.getToken();
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    return
      MultiBlocProvider(
        providers: AppBloc.providers,
        child:
        MaterialApp(
          navigatorKey: PushNotify.navigatorKey, // imp nvigator key is used as navigation through context didnt worked
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          locale: AppLanguage.defaultLanguage,

          localizationsDelegates: [
            Translate.delegate,
            // EasyLocalization.of(context).delegate,

            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          // localizationsDelegates: <LocalizationsDelegate<dynamic>>[
          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate,
          //   EasyLocalization.of(context).delegate,
          // ],
          supportedLocales: AppLanguage.supportLanguage,
          // supportedLocales: EasyLocalization.of(context).supportedLocales,
          // locale: EasyLocalization.of(context).locale,

          onGenerateRoute: route.generateRoute,
          home:
          BlocBuilder<AuthBloc, AuthenticationState>(
            builder: (context, app) {

              if (app is AuthenticationSuccess) {
                return MainNavigation();
              }
              if (app is AuthenticationFail) {
                return ChoiceScreen();
              }
              return SplashScreen();

            },
          ),

      )

      );

    //   MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //     theme: AppTheme.lightTheme,
    //     darkTheme: AppTheme.darkTheme,
    //     locale: AppLanguage.defaultLanguage,
    //
    //     localizationsDelegates: [
    //       Translate.delegate,
    //       GlobalMaterialLocalizations.delegate,
    //       GlobalWidgetsLocalizations.delegate,
    //     ],
    //     supportedLocales: AppLanguage.supportLanguage,
    //
    //     onGenerateRoute: route.generateRoute,
    //     home:
    //     MultiBlocProvider(
    //       providers: AppBloc.providers,
    //       child:
    //     BlocBuilder<AuthBloc, AuthenticationState>(
    //     builder: (context, app) {
    //       if (app is AuthenticationSuccess) {
    //         return MainNavigation();          }
    //       if (app is AuthenticationFail) {
    //         return ChoiceScreen();
    //       }
    //       return SplashScreen();
    //
    //     },
    //   ),
    // )
    // );
  }
}
