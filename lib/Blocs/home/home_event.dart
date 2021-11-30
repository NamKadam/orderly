import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeEvent {}

class OnLoadingProducerList extends HomeEvent {}
class OnLoadingProductList extends HomeEvent {
  String producerId,type,offset;
  OnLoadingProductList({this.producerId,this.type,this.offset});
}

class OnAddToCart extends HomeEvent{
  String producerId,productId,FbId,qty,price;
  OnAddToCart({this.producerId,this.productId,this.FbId,this.qty,this.price});
}
