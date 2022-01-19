class AddressResp {
  dynamic status;
  dynamic address;
  dynamic msg;

  AddressResp({this.status, this.address, this.msg});

  factory AddressResp.fromJson(Map<dynamic, dynamic> json) {
    try {
      return AddressResp(
        msg: json['msg'],
        address: json['address'],
        status: json['status'].toString(),
      );
    } catch (error) {
      return AddressResp(
        msg: false,
        address: null,
        status: '',
      );
    }
  }

}

class Address {
  int uaId;
  String userName;
  String mobile;
  String emailId;
  String address;
  String zipcode;
  String city;
  String state;
  String country;
  String streetNo;
  String flatNo;
  bool ischecked=false;

  Address(
      {this.uaId,
        this.userName,
        this.mobile,
        this.emailId,
        this.address,
        this.zipcode,
        this.city,
        this.state,
        this.country,
        this.streetNo,
        this.flatNo,
        this.ischecked});

  Address.fromJson(Map<String, dynamic> json) {
    uaId = json['ua_id'];
    userName = json['user_name'];
    mobile = json['mobile'];
    emailId = json['email_id'];
    address = json['address'];
    zipcode = json['zipcode'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    streetNo = json['street_no'];
    flatNo = json['flat_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ua_id'] = this.uaId;
    data['user_name'] = this.userName;
    data['mobile'] = this.mobile;
    data['email_id'] = this.emailId;
    data['address'] = this.address;
    data['zipcode'] = this.zipcode;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['street_no'] = this.streetNo;
    data['flat_no'] = this.flatNo;
    return data;
  }
}
