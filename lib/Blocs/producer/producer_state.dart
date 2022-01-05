import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';
import 'package:orderly/Models/model_producer_list.dart';
import 'package:orderly/Models/model_product_List.dart';

@immutable
abstract class ProducerProdState {}

class InitialProducerProdListState extends ProducerProdState {}

class ProducerTabLoading extends ProducerProdState {}
class ProductTabLoading extends ProducerProdState {}
class AddToCartTabLoading extends ProducerProdState {}

class ProducerListTabSuccess extends ProducerProdState {
  final List<Producer> producerList;
  ProducerListTabSuccess({this.producerList});
}

class ProductListTabSuccess extends ProducerProdState {
  final List<Product> productList;
  ProductListTabSuccess({this.productList});
}


class AddToCartTabSuccess extends ProducerProdState{
  String msg;
  AddToCartTabSuccess({this.msg});
}

class AddToCartTabFail extends ProducerProdState{
  String msg;
  AddToCartTabFail({this.msg});
}

class ProducerListTabLoadFail extends ProducerProdState {}
class ProductListTabLoadFail extends ProducerProdState {}
