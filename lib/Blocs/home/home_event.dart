import 'package:meta/meta.dart';

@immutable
abstract class HomeEvent {}

class OnLoadingProducerList extends HomeEvent {}
