import 'package:meta/meta.dart';

@immutable
abstract class ClaimOrdersEvent {}

class OnLoadingClaimOrdersList extends ClaimOrdersEvent {
  String producerId,claimType;
  OnLoadingClaimOrdersList({this.producerId,this.claimType});
}




