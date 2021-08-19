import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Blocs/home/bloc.dart';
import 'package:orderly/Models/ResultApiModel.dart';
import 'package:orderly/Repository/UserRepository.dart';

class HomeBloc extends Bloc<HomeEvent,HomeState>{
  HomeBloc({this.homeRepository}) : super(InitialProducerListState());
  final UserRepository homeRepository;

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async*{
    // TODO: implement mapEventToState
    if(event is OnLoadingProducerList){
      yield ProducerLoading();

      // final ResultApiModel response=await homeRepository.load

    }
  }

  
}