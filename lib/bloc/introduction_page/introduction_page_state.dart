part of 'introduction_page_bloc.dart';

@immutable
abstract class IntroductionPageState {}

class IntroductionPageInitial extends IntroductionPageState {}

class LoadingIntroductionState extends IntroductionPageState {}

class LoadedIntroductionState extends IntroductionPageState {
  final List<DocServiceModel> docService;
  final List<DoctorModel> doctor;
  LoadedIntroductionState({this.docService, this.doctor});
}

class ErrorIntroductionState extends IntroductionPageState {
  final String error;
  ErrorIntroductionState(this.error);
}
