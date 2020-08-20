import 'dart:async';
import 'dart:io';
import 'package:anzer_schedule_app/network/api_service.dart';
import 'package:anzer_schedule_app/network/model/submit_app_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'alldone_page_event.dart';
part 'alldone_page_state.dart';

class AlldonePageBloc extends Bloc<AlldonePageEvent, AlldonePageState> {
  ApiService api;
  AlldonePageBloc({@required this.api}) : assert(api != null);
  @override
  AlldonePageState get initialState => AlldonePageInitial();

  @override
  Stream<AlldonePageState> mapEventToState(
    AlldonePageEvent event,
  ) async* {
    if (event is SubmitAppEvent) {
      yield LoadingSubmitAppState();
      try {
        final response = await api.submitAppointment(event.appModel);
        print('response of sumitAppointment > $response');
        yield LoadedSumbitAppState();
      } on SocketException catch (e) {
        yield ErrorSubmitAppState(e.toString());
      } on Exception catch (e) {
        yield ErrorSubmitAppState(e.toString());
      }
    }
  }
}
