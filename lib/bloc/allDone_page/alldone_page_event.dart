part of 'alldone_page_bloc.dart';

@immutable
abstract class AlldonePageEvent {}

class SubmitAppEvent extends AlldonePageEvent {
  final SubmitAppModel appModel;
  SubmitAppEvent({@required this.appModel}) : assert(appModel != null);
}
