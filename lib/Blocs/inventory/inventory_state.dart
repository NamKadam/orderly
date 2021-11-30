import 'package:meta/meta.dart';
import 'package:orderly/Models/model_invent_list.dart';


@immutable
abstract class InventoryState {}

class InitialInventoryListState extends InventoryState {}

class InventoryLoading extends InventoryState {}
class InventoryAddEditLoading extends InventoryState {}

class InventoryListSuccess extends InventoryState {
  final List<Inventory> inventoryList;
  InventoryListSuccess({this.inventoryList});
}

class InventoryRemovedSuccess extends InventoryState {
  InventoryRemovedSuccess();
}

class InventoryAddedSuccess extends InventoryState {
  InventoryAddedSuccess();
}

class InventoryUpdatedSuccess extends InventoryState {
  InventoryUpdatedSuccess();
}

class InventoryListLoadFail extends InventoryState {}
class InventoryRemovedFail extends InventoryState {}
class InventoryAddedFail extends InventoryState {}
class InventoryUpdatedFail extends InventoryState {}
