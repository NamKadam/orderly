import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';

//for multipart
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/authentication/authentication_event.dart';
import 'package:orderly/Blocs/user_reg/userReg_event.dart';
import 'package:orderly/Blocs/user_reg/userReg_state.dart';
import 'package:orderly/Models/model_user.dart';
import 'package:orderly/Repository/UserRepository.dart';
import 'package:orderly/app_bloc.dart';
import 'package:mime/mime.dart';



class UserRegBloc extends Bloc<UserRegEvent, UserRegState> {
  UserRegBloc({this.userRepository}) : super(InitialUserRegisteState());
  final UserRepository userRepository;

  @override
  Stream<UserRegState> mapEventToState(event) async* {
    Uri url=Uri.parse("http://93.188.162.210:3000/register");
    if(event is OnUserRegister){
      ///Notify loading to UI
        yield FetchingUserRegister();

        Map<String, String> params={
          'first_name':event.firstName,
          'last_name':event.lastName,
          'user_email':event.email,
          'gender':'Female',
           'version':event.version,
          'fb_id':event.firebaseId,
          'signup_type':event.signupType,
          'device_id':event.deviceId,
          'fcm_id':event.fcmId,
          'mobile':event.mobile,
          'device':event.deviceName,
          'latitude':event.lat,
          'longitude':event.lng,
          'user_type':event.userType,
           'zip_code':event.zipcode,
          'address':event.address
        };

        var response = await http.post(
            url,
            body:params
        );

        try{
          if (response.statusCode == 200) {
            final resp = json.decode(response.body);

            final UserModel userModel = UserModel.fromJson(resp);
            ///Begin start AuthBloc Event AuthenticationSave
            AppBloc.authBloc.add(OnSaveUser(userModel.user));


            ///Notify loading to UI
            yield RegisterUserSuccess(
                user: userModel.user
            );

          }
        }catch(e)
        {
          yield RegisterUserFail(msg: "Registered fail");
        }

    }





    ///Event for Vendor Reg
    // if (event is OnUserRegister) {
    //   ///Notify loading to UI
    //   yield FetchingUserRegister();
    //
    //   MultipartRequest request = new MultipartRequest('POST', updateStatusUrl);
    //
    //   request.fields['firstname'] = event.firstName;
    //   request.fields['lastname'] = event.lastName;
    //   request.fields['email'] = event.email;
    //   request.fields['password'] = event.password;
    //   request.fields['mobile'] = event.mobile;
    //   request.fields['address'] = event.address;
    //   request.fields['zip_code'] = event.zipcode;
    //
    //   //updated on 12/02/2021 for single profile photo
    //   List<MultipartFile> imageUploadReqListSingle = <MultipartFile>[];
    //
    //   final mimeTypeDataProfile = lookupMimeType(
    //       event.profile_photo!.imagePath.toString(), headerBytes: [0xFF, 0xD8])!.split('/');
    //   //initialize multipart request
    //   //attach the file in the request
    //   final multipartFile = await http.MultipartFile.fromPath(
    //       'user_img', event.profile_photo!.imagePath.toString(),
    //       contentType: MediaType(mimeTypeDataProfile[0], mimeTypeDataProfile[1]));
    //
    //   imageUploadReqListSingle.add(multipartFile);
    //
    //   request.files.addAll(imageUploadReqListSingle);
    //
    //   ///Case API fail but not have token
    //   // try {
    //   final streamedResponse = await request.send();
    //   final response = await http.Response.fromStream(streamedResponse);
    //   var responseData = json.decode(response.body);
    //   print(responseData);
    //   var message=responseData['message'];
    //   if (responseData['success']==true) {
    //     var data = responseData['data'];
    //     var user = data['user'];
    //     ///register API success
    //     final UserModel userModel = UserModel.fromJson(user);
    //
    //     try {
    //       ///Begin start AuthBloc Event AuthenticationSave
    //       AppBloc.authBloc.add(OnSaveUser(userModel));
    //
    //       ///Notify loading to UI
    //       yield RegisterUserSuccess(
    //        user: userModel
    //       );
    //     } catch (error) {
    //       ///Notify loading to UI
    //       yield RegisterUserFail(msg: message);
    //     }
    //   } else {
    //     ///Notify loading to UI
    //     yield RegisterUserFail(msg: message);
    //   }
    //   // } catch (e) {
    //   //   print(e);
    //   // }
    // }



  }
}
