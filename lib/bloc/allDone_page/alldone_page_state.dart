part of 'alldone_page_bloc.dart';

@immutable
abstract class AlldonePageState {}

class AlldonePageInitial extends AlldonePageState {}

class LoadingSubmitAppState extends AlldonePageState{}

class LoadedSumbitAppState extends AlldonePageState{
  // final SubmitAppModel appModel;
  // LoadedSumbitAppState({@required this.appModel});
}

class ErrorSubmitAppState extends AlldonePageState{
  final String error;
  ErrorSubmitAppState(this.error);
}