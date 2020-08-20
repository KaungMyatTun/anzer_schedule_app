import 'dart:async';
import 'dart:io';

import 'package:anzer_schedule_app/network/api_service.dart';
import 'package:anzer_schedule_app/network/model/doc_service_model.dart';
import 'package:anzer_schedule_app/network/model/doctor_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'introduction_page_event.dart';
part 'introduction_page_state.dart';

class IntroductionPageBloc
    extends Bloc<IntroductionPageEvent, IntroductionPageState> {
  ApiService api;
  IntroductionPageBloc({@required this.api}) : assert(api != null);

  @override
  IntroductionPageState get initialState => IntroductionPageInitial();

  @override
  Stream<IntroductionPageState> mapEventToState(
    IntroductionPageEvent event,
  ) async* {
    if (event is GetPreRequiredData) {
      yield LoadingIntroductionState();
      try {
        final response1 = await api.getDoctorServices();
        final response2 = await api.getDoctor();
        yield LoadedIntroductionState(docService: response1, doctor: response2);
      } on SocketException catch (e) {
        yield ErrorIntroductionState(e.toString());
      } on Exception catch (e) {
        yield ErrorIntroductionState(e.toString());
      }
    }
  }
}
