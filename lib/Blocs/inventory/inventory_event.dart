import 'package:meta/meta.dart';

@immutable
abstract class InventoryEvent {}

class OnLoadingInventoryList extends InventoryEvent {
  String producerId;
  OnLoadingInventoryList({this.producerId});
}

class OnRemoveInventoryItem extends InventoryEvent {
  String productId;
  OnRemoveInventoryItem({this.productId});
}

class OnAddInventoryItem extends InventoryEvent {
  String title,desc,rate,qty;
  OnAddInventoryItem({this.title,this.desc,this.rate,this.qty});
}

class OnEditInventoryItem extends InventoryEvent {
  String prodId,title,desc,rate,qty;
  OnEditInventoryItem({this.prodId,this.title,this.desc,this.rate,this.qty});
}




