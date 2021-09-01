import 'package:orderly/Models/model_user.dart';
class ResultApiModel {
  dynamic status;
  dynamic user;
  dynamic msg;

  ResultApiModel({this.status, this.user, this.msg});

  // ResultApiModel.fromJson(Map<String, dynamic> json) {
  //   status = json['status'];
  //   user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
  //   msg = json['msg'];
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['status'] = this.status;
  //   if (this.user != null) {
  //     data['user'] = this.user.toJson();
  //   }
  //   data['msg'] = this.msg;
  //   return data;
  // }

  factory ResultApiModel.fromJson(Map<dynamic, dynamic> json) {
    try {
      return ResultApiModel(
        msg: json['msg'],
        user: json['user'],
        // pagination: json['data']['pagination'],
        status: json['status'].toString(),
      );
    } catch (error) {
      return ResultApiModel(
        msg: false,
        user: null,
         status: '',
      );
    }
  }

}


// class ResultApiModel {
//   final dynamic success;
//   final dynamic message;
//   final dynamic data;
//   final dynamic pagination;
//   final dynamic attr;
//   final dynamic code;
//
//   ResultApiModel({
//     this.success,
//     this.message,
//     this.data,
//     this.pagination,
//     this.attr,
//     this.code,
//  });
//
//   factory ResultApiModel.fromJson(Map<dynamic, dynamic> json) {
//     try {
//       return ResultApiModel(
//         success: json['success'],
//         message: json['message'] ,
//         data: json['data'],
//         // pagination: json['data']['pagination'],
//         pagination: json['pagination'], //updated on 4/12/2020
//         attr: json['attr'],
//         code: json['code'].toString(),
//       );
//     } catch (error) {
//       return ResultApiModel(
//         success: false,
//         data: null,
//         message: "cannot init result api", code: '',
//       );
//     }
//   }
// }
