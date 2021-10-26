import 'package:meta/meta.dart';
import 'package:orderly/Models/model_return_reason.dart';

@immutable
abstract class CustOrdersDetEvent {}

class SendProductReview extends CustOrdersDetEvent {
  String orderNum,appExp,VehicleQty,driveExp,payExp,overall,fbId,prodId,comment;
  SendProductReview({this.orderNum,this.appExp,this.VehicleQty,this.driveExp,this.payExp,this.overall,
    this.fbId,this.prodId,this.comment});
}

class sendReturnReplace extends CustOrdersDetEvent {
  String orderNum,returnType,returnTitle,review,orderdetailsId,fbId,prodId,status;
  sendReturnReplace({this.orderNum,this.returnType,this.returnTitle,this.review,this.orderdetailsId,
    this.fbId,this.prodId,this.status});
}

class getReturnOrderReason extends CustOrdersDetEvent {
  getReturnOrderReason();
}





