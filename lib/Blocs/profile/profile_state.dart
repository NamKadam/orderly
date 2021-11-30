import 'package:orderly/Models/model_faqList.dart';
import 'package:orderly/Models/model_user.dart';

abstract class ProfileState {}

class InitialProfileState extends ProfileState {}

class FetchEditProf extends ProfileState {}
class OnLoadingProf extends ProfileState {}

class EditProfSuccess extends ProfileState {
  User user;

  EditProfSuccess({this.user});

}

class FAQProfSuccess extends ProfileState {
  List<Faq> faqList;
  FAQProfSuccess({this.faqList});
}

class FAQProfFail extends ProfileState {
  FAQProfFail();
}

class EditProfFail extends ProfileState {
  final String msg;
  EditProfFail({this.msg});
}
