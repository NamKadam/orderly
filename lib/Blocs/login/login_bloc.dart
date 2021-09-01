import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:orderly/Blocs/authentication/authentication_event.dart';
import 'package:orderly/Blocs/login/login_event.dart';
import 'package:orderly/Blocs/login/login_state.dart';
import 'package:orderly/Models/ResultApiModel.dart';
import 'package:orderly/Models/model_user.dart';
import 'package:orderly/Repository/UserRepository.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/app_bloc.dart';
import 'package:http/http.dart' as http;


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({this.userRepository}) : super(InitialLoginState());
  final UserRepository userRepository;


  @override
  Stream<LoginState> mapEventToState(event) async* {
    Uri url=Uri.parse("http://93.188.162.210:3000/login");

    // if(event is OnLogin){
    //   yield LoginLoading();
    //
    //   Map<String,String> params={
    //     'fb_id':event.fbId,
    //   };
    //
    //
    // //dio is used bcoz in http json.encode does not gives proper format if need to post parameters in JSONOBJect
    // //  Dio dio=Dio();
    //  // var response = await dio.post(
    //  //      url.toString(),
    //  //     // headers: {"Accept":"application/json",
    //  //     // "Content-Type":"application/x-www-form-urlencoded"},
    //  //
    //  //      data: params,
    //  //  );
    //
    //   var response = await http.post(
    //     url,
    //     body: params,
    //   );
    //
    //   try{
    //
    //     if (response.statusCode == 200) {
    //
    //
    //       var resp = json.decode(response.body); //for dio dont need to convert to json.decode
    //       // final UserModel userModel = UserModel.fromJson(response.data);//for dio
    //       final UserModel userModel = UserModel.fromJson(resp);
    //       if(userModel.msg=="Success"){
    //         AppBloc.authBloc.add(OnSaveUser(userModel.user));
    //
    //       }
    //       ///Begin start AuthBloc Event AuthenticationSave
    //       ///Notify loading to UI
    //       yield LoginSuccess(
    //           userModel: userModel.user
    //       );
    //
    //     }
    //   }catch(e)
    //   {
    //     yield LoginFail(msg:"");
    //   }
    //
    // }

    ///Event for login
    if (event is OnLogin) {
      ///Notify loading to UI
      yield LoginLoading();

      ///Fetch API via repository
      final ResultApiModel result = await userRepository.login(
        fbId: event.fbId
      );
      ///Case API fail but not have token
      if (result.msg=="Success") {
        ///Login API success
        final User user = User.fromJson(result.user);
        try {
          ///Begin start AuthBloc Event AuthenticationSave
          AppBloc.authBloc.add(OnSaveUser(user));
          yield LoginSuccess(userModel: user);
        } catch (error) {
          ///Notify loading to UI
          yield LoginFail(msg: result.msg);
        }
      } else {
        ///Notify loading to UI
        yield LoginFail(msg:result.msg);
      }
    }


    ///Event for logout
    if (event is OnLogout) {
      yield LogoutLoading();
      try {
        ///Begin start AuthBloc Event OnProcessLogout
        // AppBloc.authBloc.add(OnClear());
       //updated on 10/02/2021
        final deletePreferences = await userRepository.deleteUser();

        ///Clear user Storage user via repository
        Application.user = null;

        // ///Clear token httpManager
        // httpManager.getOption.headers = {};
        // httpManager.postOption.headers = {};
        ///Notify loading to UI
        /////updated on 10/02/2021
        if (deletePreferences) {
          yield LogoutSuccess();
              } else {
                final String message = "Cannot delete user data to storage phone";
                throw Exception(message);
              }
        // yield LogoutSuccess();
      } catch (error) {
        ///Notify loading to UI
        yield LogoutFail(error.toString());
      }
    }
  }
}
