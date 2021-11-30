import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/address/address_event.dart';
import 'package:orderly/Blocs/address/address_state.dart';
import 'package:orderly/Blocs/claim/bloc.dart';
import 'package:orderly/Blocs/fleetOrders/bloc.dart';
import 'package:orderly/Blocs/home/bloc.dart';
import 'package:orderly/Blocs/myOrders/bloc.dart';
import 'package:orderly/Blocs/mycart/bloc.dart';
import 'package:orderly/Models/model_address.dart';
import 'package:orderly/Models/model_claim.dart';
import 'package:orderly/Repository/UserRepository.dart';



class ClaimOrdersBloc extends Bloc<ClaimOrdersEvent,ClaimOrdersState> {
  ClaimOrdersBloc({this.claimRepo}) : super(InitialClaimOrdersListState());
  final UserRepository claimRepo;

  @override
  Stream<ClaimOrdersState> mapEventToState(ClaimOrdersEvent event) async* {
    // TODO: implement mapEventToState

    //for fleet order list
    if (event is OnLoadingClaimOrdersList) {
      yield ClaimOrdersLoading();

      final ClaimResp response = await claimRepo.fetchClaimOrdersList(
          producerId: event.producerId,
          claimType: event.claimType
      );
      try {
          String recievedAmt=response.claimDetails.receivedAmount;
          String refundedAmt=response.claimDetails.refundedAmount.toString();
        final Iterable refactorCategory = response.claimDetails.claimData ?? [];
        List<ClaimData> listClaim=refactorCategory.toList();
        // final listClaim = refactorCategory.map((item) {
        //   return ClaimData.fromJson(item);
        // }).toList();

        ///Sync UI
          if(listClaim.length>0)
            {
        yield ClaimOrdersListSuccess(claimList: listClaim,receivedAmt: recievedAmt,refundedAmt: refundedAmt);
        } else {
          yield ClaimOrdersListLoadFail();
        }
      } catch (e) {
        print(e);
        yield ClaimOrdersListLoadFail();
      }
    }
  }
}



