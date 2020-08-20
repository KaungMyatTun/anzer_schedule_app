import 'dart:async';
import 'dart:io';

import 'package:anzer_schedule_app/bloc/introduction_page/introduction_page_bloc.dart';
import 'package:anzer_schedule_app/network/api_service.dart';
import 'package:anzer_schedule_app/network/model/available_date_time_model.dart';
import 'package:anzer_schedule_app/network/model/doc_service_model.dart';
import 'package:anzer_schedule_app/network/model/doctor_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'request_appointment_data_event.dart';
part 'request_appointment_data_state.dart';

class RequestAppointmentDataBloc
    extends Bloc<RequestAppointmentDataEvent, RequestAppointmentDataState> {
  ApiService api;
  RequestAppointmentDataBloc({@required this.api});
  @override
  RequestAppointmentDataState get initialState =>
      RequestAppointmentDataInitial();

  @override
  Stream<RequestAppointmentDataState> mapEventToState(
    RequestAppointmentDataEvent event,
  ) async* {
    if (event is GetPreRequiredData) {
      yield LoadingGetPreRequiredDataState();
      try {
        final response1 = await api.getDoctorServices();
        final response2 = await api.getDoctor();

        yield LoadedGetPreRequiredDataState(
            docService: response1, doctor: response2);
      } on SocketException catch (e) {
        yield ErrorGetPreRequiredDataState(e.toString());
      } on Exception catch (e) {
        yield ErrorGetPreRequiredDataState(e.toString());
      }
    }
    if (event is ChangeSpecialityEvent) {
      yield LoadingChangeSpecialityState();
      yield DidChangeSpecialityState();
    }
    if (event is GetDoctorScheduleEvent) {
      yield LoadingGetDoctorScheduleState();
      try {
        final response = await api.getAvailableDateAndTime(
            event.hospitalInst,
            event.startDate,
            event.endDate,
            event.deptCode,
            event.resType,
            event.docCode);
        yield LoadedGetDoctorScheduleState(avaialbleDateAndTime: response);
      } on SocketException catch (e) {
        yield ErrorGetDoctorScheduleState(e.toString());
      } on Exception catch (e) {
        yield ErrorGetDoctorScheduleState(e.toString());
      }
    }
  }
}
