import 'dart:async';
import 'dart:convert';

import 'package:orderly/Blocs/authentication/authentication_event.dart';
import 'package:orderly/Blocs/authentication/authentication_state.dart';
import 'package:orderly/Models/model_user.dart';
import 'package:orderly/Models/model_view_cart.dart';
import 'package:orderly/Repository/UserRepository.dart';
import 'package:orderly/Utils/application.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Utils/preferences.dart';
import 'package:orderly/Utils/util_preferences.dart';

import '../../app_bloc.dart';



class AuthBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthBloc({this.userRepository}) : super(InitialAuthenticationState());
  final UserRepository userRepository;

  @override
  Stream<AuthenticationState> mapEventToState(event) async* {
    if (event is OnAuthCheck) {
      ///Notify state AuthenticationBeginCheck
      yield AuthenticationBeginCheck();
      final hasUser = userRepository.getUser();
      final hasProfile = userRepository.getProfile();

      if (hasUser!=null ) {
        ///Getting data from Storage
        final userModel = User.fromJson(jsonDecode(hasUser));

        ///Set token network
        // httpManager.getOption.headers["Authorization"] = "Bearer " + user.token;
        // httpManager.postOption.headers["Authorization"] =
        //     "Bearer " + user.token;

        ///Valid token server
        // final ResultApiModel result = await userRepository.validateToken(); //commented on 17/12/2020

        ///Fetch api success
        if (userModel.fbId!=null && userModel.isRegistered=="true") {
          ///Set user
          Application.user = userModel;
          yield AuthenticationSuccess();

        } else {
          ///Fetch api fail
          ///Delete user when can't verify token
          await userRepository.deleteUser();

          ///Notify loading to UI
          yield AuthenticationFail();
        }
      }
      //updated on 10/02/2021
      else {
        ///Notify loading to UI
        ///
        yield AuthenticationFail();
      }

      //for profile pic
      if(hasProfile!=null)
      {
        if (Application.user.fbId!=null && Application.user.isRegistered=="true") {
          ///Set user
          Application.profile_pic=hasProfile;
          yield AuthenticationSuccess();

        } else {

          ///Notify loading to UI
          yield AuthenticationFail();
        }

      }
    }

    if (event is OnSaveUser) {
      ///Save to Storage user via repository
      final savePreferences = await userRepository.saveUser(event.user);

      ///Check result save user
      if (savePreferences) {
        ///Set token network
        // httpManager.getOption.headers["Authorization"] =
        //     "Bearer " + event.user.token;
        // httpManager.postOption.headers["Authorization"] =
        //     "Bearer " + event.user.token;

        ///Set user
        Application.user = event.user;
        // UtilPreferences.setString(Preferences.user, Application.user.toString());

        ///Notify loading to UI
        if(Application.user.fbId!=null && Application.user.isRegistered=="true") {
          yield AuthenticationSuccess();
        }else{
          yield AuthenticationFail();
        }


      } else {
        final String message = "Cannot save user data to storage phone";
        throw Exception(message);
      }
    }
    if (event is OnSaveImage) {
      ///Save to Storage user via repository
      final savePreferences = await userRepository.saveImage(event.profilePic);

      ///Check result save user
      if (savePreferences) {
        ///Set token network
        // httpManager.getOption.headers["Authorization"] =
        //     "Bearer " + event.user.token;
        // httpManager.postOption.headers["Authorization"] =
        //     "Bearer " + event.user.token;

        ///Set user
        Application.profile_pic = event.profilePic;
        // UtilPreferences.setString(Preferences.user, Application.user.toString());

        ///Notify loading to UI
        if(Application.user.fbId!=null && Application.user.isRegistered=="true") {
          yield AuthenticationSuccess();
        }else{
          yield AuthenticationFail();
        }


      } else {
        final String message = "Cannot save user data to storage phone";
        throw Exception(message);
      }
    }


    //updated for cart List
    if (event is OnSaveCart) {
      ///Save to Storage user via repository
      final savePreferences = await userRepository.saveCart(event.cartModel);

      ///Check result save user
      if (savePreferences) {
        ///Set token network
        // httpManager.getOption.headers["Authorization"] =
        //     "Bearer " + event.user.token;
        // httpManager.postOption.headers["Authorization"] =
        //     "Bearer " + event.user.token;

        ///Set user
        Application.cartModel = event.cartModel;
        // UtilPreferences.setString(Preferences.user, Application.user.toString());

        ///Notify loading to UI
        yield AuthenticationSuccess();

      } else {
        final String message = "Cannot save user data to storage phone";
        throw Exception(message);
      }
    }


    if (event is OnClear) {
      ///Delete user
      final deletePreferences = await userRepository.deleteUser();

      ///Clear user Storage user via repository
      Application.user = null;

      ///Check result delete user
      if (deletePreferences) {
        yield AuthenticationFail();
      } else {
        final String message = "Cannot delete user data to storage phone";
        throw Exception(message);
      }
    }

  }
}
