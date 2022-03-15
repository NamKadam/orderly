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

    if(event is UploadImage) {
      yield OnLoadingImage();

      MultipartRequest request = new MultipartRequest(
          'POST', Uri.parse(Api.UPLOAD_IMAGE));

      request.fields['fb_id'] = Application.user.fbId;

      List<MultipartFile> imageUploadReqListSingle = <MultipartFile>[];
      final mimeTypeDataProfile = lookupMimeType(
          event.image.imagePath.toString(), headerBytes: [0xFF, 0xD8]).split(
          '/');
      //initialize multipart request
      //attach the file in the request
      final multipartFile = await http.MultipartFile.fromPath(
          'image', event.image.imagePath.toString(),
          contentType: MediaType(
              mimeTypeDataProfile[0], mimeTypeDataProfile[1]));

      imageUploadReqListSingle.add(multipartFile);
      request.files.addAll(imageUploadReqListSingle);
      try {
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        var responseData = json.decode(response.body);
        print(responseData);
        if (responseData['msg'] == "Successed") {
          var image = responseData['profile_pic'];

          ///Begin start AuthBloc Event AuthenticationSave
          AppBloc.authBloc.add(OnSaveImage(image));

          ///Notify loading to UI
          yield UploadImageSuccess(
              msg: responseData['msg']
          );
        }
      } catch (error) {
    ///Notify loading to UI
    // yield RegisterUserFail(msg: message);
        print(error);
    }
    }


  }
}
