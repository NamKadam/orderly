import 'package:meta/meta.dart';

@immutable
abstract class CartEvent {}

class OnLoadingCartList extends CartEvent {
  String fbId;
  OnLoadingCartList({this.fbId});
}