import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ProducerProdEvent {}

class OnLoadingProducerTabList extends ProducerProdEvent {
  String latitude,longitude;
  OnLoadingProducerTabList({this.latitude,this.longitude});
}
class OnLoadingProductTabList extends ProducerProdEvent {
  String producerId,type,offset;
  OnLoadingProductTabList({this.producerId,this.type,this.offset});
}

class OnAddToCartTab extends ProducerProdEvent{
  String producerId,productId,FbId,qty,price;
  OnAddToCartTab({this.producerId,this.productId,this.FbId,this.qty,this.price});
}


