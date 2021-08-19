import 'package:meta/meta.dart';

@immutable
abstract class HomeState {}

class InitialProducerListState extends HomeState {}

class ProducerLoading extends HomeState {}

class ProducerListSuccess extends HomeState {
  // final List<String> banner;
  // final List<CategoryModel> category;
  // final List<CategoryModel> location;
  // final List<ProductModel> recent;

  // HomeSuccess({this.banner, this.category, this.location, this.recent});
}

class ProducerListLoadFail extends HomeState {}
