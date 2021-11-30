import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';

//for multipart
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/authentication/authentication_event.dart';
import 'package:orderly/Blocs/profile/profile_event.dart';
import 'package:orderly/Blocs/profile/profile_state.dart';
import 'package:orderly/Blocs/user_reg/userReg_event.dart';
import 'package:orderly/Blocs/user_reg/userReg_state.dart';
import 'package:orderly/Models/model_faqList.dart';
import 'package:orderly/Models/model_user.dart';
import 'package:orderly/Repository/UserRepository.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/app_bloc.dart';
import 'package:mime/mime.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({this.profileRepo}) : super(InitialProfileState());
  final UserRepository profileRepo;

  @override
  Stream<ProfileState> mapEventToState(event) async* {

    if(event is EditProf){

      ///Notify loading to UI
      yield FetchEditProf();

      Map<String, String> params={
        'fb_id':Application.user.fbId,
        'first_name':event.firstName,
        'last_name':event.lastName,
        'email_id':event.email,
        'zip_code':event.zipcode,
        'address':event.address,
        'mobile':event.mobile
      };

      var response = await http.post(
        Uri.parse(Api.EDIT_PROFILE),
        body:params,
      );

      try{
        if (response.statusCode == 200) {
          final resp = json.decode(response.body);
          final UserModel userModel = UserModel.fromJson(resp);
          ///Begin start AuthBloc Event AuthenticationSave
          AppBloc.authBloc.add(OnSaveUser(userModel.user));
          ///Notify loading to UI
          yield EditProfSuccess(
              user: userModel.user
          );
        }
      }catch(e)
      {
        yield EditProfFail(msg: "Registered fail");
      }
    }

    //faq
    if(event is FetchFAQ){

      ///Notify loading to UI
      yield OnLoadingProf();

      final FAQResp result = await profileRepo.getFAQList();
      try{
        final Iterable refactorCategory = result.faq ?? [];
        final listfaq = refactorCategory.map((item) {
          return Faq.fromJson(item);
        }).toList();

        yield FAQProfSuccess(faqList: listfaq);
      }catch(e)
      {
        yield FAQProfFail();
      }
    }


  }
}
