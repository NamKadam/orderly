class UserModel {
  dynamic status;
  dynamic user;
  dynamic msg;

  UserModel({this.status, this.user, this.msg});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class User {
  dynamic userId;
  dynamic fbId;
  dynamic firstName;
  dynamic lastName;
  dynamic emailId;
  dynamic mobile;
  dynamic userType;
  dynamic isRegistered;

  User(
      {this.userId,
        this.fbId,
        this.firstName,
        this.lastName,
        this.emailId,
        this.mobile,
        this.userType,
        this.isRegistered});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    fbId = json['fb_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    emailId = json['email_id'];
    mobile = json['mobile'];
    userType = json['user_type'];
    isRegistered = json['is_registered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['fb_id'] = this.fbId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email_id'] = this.emailId;
    data['mobile'] = this.mobile;
    data['user_type'] = this.userType;
    data['is_registered'] = this.isRegistered;
    return data;
  }
}


// class UserModel {
//   String? fbId;
//   String? firstName;
//   String? lastName;
//   String? emailId;
//   String? mobile;
//   String? isRegistered;
//   String? userId;
//
//   UserModel(
//       {this.fbId,
//         this.firstName,
//         this.lastName,
//         this.emailId,
//         this.mobile,
//         this.isRegistered,this.userId});
//
//   UserModel.fromJson(Map<String, dynamic> json) {
//     fbId = json['fb_id'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     emailId = json['email_id'];
//     mobile = json['mobile'];
//     isRegistered = json['is_registered'];
//     userId = json['user_id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['fb_id'] = this.fbId;
//     data['first_name'] = this.firstName;
//     data['last_name'] = this.lastName;
//     data['email_id'] = this.emailId;
//     data['mobile'] = this.mobile;
//     data['is_registered'] = this.isRegistered;
//     data['user_id'] = this.userId;
//     return data;
//   }
// }




