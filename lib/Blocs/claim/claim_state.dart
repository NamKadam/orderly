import 'package:meta/meta.dart';
import 'package:orderly/Models/model_claim.dart';


@immutable
abstract class ClaimOrdersState {}

class InitialClaimOrdersListState extends ClaimOrdersState {}

class ClaimOrdersLoading extends ClaimOrdersState {}

class ClaimOrdersListSuccess extends ClaimOrdersState {
  final List<ClaimData> claimList;
  String receivedAmt,refundedAmt;
  ClaimOrdersListSuccess({this.claimList,this.receivedAmt,this.refundedAmt});
}

class ClaimOrdersListLoadFail extends ClaimOrdersState {}


