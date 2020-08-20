import 'dart:async';
import 'dart:io';

import 'package:anzer_schedule_app/bloc/request_appointment_data/request_appointment_data_bloc.dart';
import 'package:anzer_schedule_app/network/api_service.dart';
import 'package:anzer_schedule_app/network/model/doc_service_model.dart';
import 'package:anzer_schedule_app/network/model/doctor_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  ApiService api;
  HomePageBloc({@required this.api}) : assert(api != null);
  @override
  HomePageState get initialState => HomePageInitial();

  @override
  Stream<HomePageState> mapEventToState(
    HomePageEvent event,
  ) async* {
    if (event is YesEvent) {
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
      yield YesCompleteState();
    }
    if (event is NoEvent) {
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
      yield NoCompleteState();
    }
  }
}
