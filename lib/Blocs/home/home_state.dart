import 'package:meta/meta.dart';
import 'package:orderly/Models/model_producer_list.dart';
import 'package:orderly/Models/productList_scopedModel.dart';

@immutable
abstract class HomeState {}

class InitialProducerListState extends HomeState {}
class InitialProductListState extends HomeState {}

class ProducerLoading extends HomeState {}
class ProductLoading extends HomeState {}
class AddToCartLoading extends HomeState {}

class ProducerListSuccess extends HomeState {
  final List<Producer> producerList;
  ProducerListSuccess({this.producerList});
}

class ProductListSuccess extends HomeState {
  final List<Product> productList;
  ProductListSuccess({this.productList});
}

class AddToCartSuccess extends HomeState{
  String msg;
  AddToCartSuccess({this.msg});
}

class AddToCartFail extends HomeState{
  String msg;
  AddToCartFail({this.msg});
}

class ProducerListLoadFail extends HomeState {}
class ProductListLoadFail extends HomeState {}