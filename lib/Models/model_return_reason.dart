class ReturnReasonResp {
  dynamic status;
  dynamic charges;
  dynamic msg;

  ReturnReasonResp({this.status, this.charges, this.msg});

  factory ReturnReasonResp.fromJson(Map<dynamic, dynamic> json) {
    try {
      return ReturnReasonResp(
        msg: json['msg'],
        charges: json['charges'],
        status: json['status'].toString(),
      );
    } catch (error) {
      return ReturnReasonResp(
        msg: false,
        charges: null,
        status: '',
      );
    }
  }

}

class Reasons {
  int reasonId;
  String reason;
  bool ischecked=false;


  Reasons({this.reasonId, this.reason,this.ischecked});

  Reasons.fromJson(Map<String, dynamic> json) {
    reasonId = json['reason_id'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reason_id'] = this.reasonId;
    data['reason'] = this.reason;
    return data;
  }
}
