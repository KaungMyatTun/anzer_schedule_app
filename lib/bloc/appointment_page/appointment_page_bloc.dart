import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'appointment_page_event.dart';
part 'appointment_page_state.dart';

class AppointmentPageBloc
    extends Bloc<AppointmentPageEvent, AppointmentPageState> {
  @override
  AppointmentPageState get initialState => AppointmentPageInitial();

  @override
  Stream<AppointmentPageState> mapEventToState(
    AppointmentPageEvent event,
  ) async* {
    if (event is SetPatientInfoEvent) {
      yield LoadingSetPatientInfoState();
      yield LoadedSetPatientInfoState();
    }
  }
}
