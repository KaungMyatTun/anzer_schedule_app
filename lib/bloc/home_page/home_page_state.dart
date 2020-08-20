part of 'home_page_bloc.dart';

@immutable
abstract class HomePageState {}

class HomePageInitial extends HomePageState {}

class YesCompleteState extends HomePageState{}

class NoCompleteState extends HomePageState{}

class LoadingGetPreRequiredDataState extends HomePageState{}

class LoadedGetPreRequiredDataState extends HomePageState{
  final List<DocServiceModel> docService;
  final List<DoctorModel> doctor;
  LoadedGetPreRequiredDataState({this.docService, this.doctor});
}

class ErrorGetPreRequiredDataState extends HomePageState{
  final String error;
  ErrorGetPreRequiredDataState(this.error);
}