import 'dart:async';
import 'dart:io';

import 'package:anzer_schedule_app/network/api_service.dart';
import 'package:anzer_schedule_app/network/model/otp_model.dart';
import 'package:anzer_schedule_app/network/model/pt_info.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'request_verify_otp_event.dart';
part 'request_verify_otp_state.dart';

class RequestVerifyOtpBloc
    extends Bloc<RequestVerifyOtpEvent, RequestVerifyOtpState> {
  ApiService api;
  RequestVerifyOtpBloc({@required this.api}) : assert(api != null);

  @override
  RequestVerifyOtpState get initialState => RequestVerifyOtpInitial();

  @override
  Stream<RequestVerifyOtpState> mapEventToState(
    RequestVerifyOtpEvent event,
  ) async* {
    // get one time password
    if (event is GetOTPEvent) {
      yield LoadingGetOTPState();
      try {
        final response = await api.getOTP(event.cpi);
        yield LoadedGetOTPState(otpModel: response);
      } on SocketException catch (e) {
        yield ErrorGetOTPState(e.toString());
      } on Exception catch (e) {
        yield ErrorGetOTPState(e.toString());
      }
    }
    // verify one time password
    if (event is VerifyOTPEvent) {
      yield LoadingVerifyOTPState();
      try {
        final response = await api.verifyOTP(event.cpi, event.otpCode);
        yield LoadedVerifyOTPState();
      } on SocketException catch (e) {
        yield ErrorVerifyOTPState(e.toString());
      } on Exception catch (e) {
        yield ErrorVerifyOTPState(e.toString());
      }
    }
    // get patient information after verification is successful
    if (event is GetPtInfoEvent) {
      yield LoadingPtInfoState();
      try {
        final response = await api.getPtInfo(event.cpi);
        yield LoadedPtInfoState(ptInfo: response);
      } on SocketException catch (e) {
        yield ErrorPtInfoState(e.toString());
      } on Exception catch (e) {
        yield ErrorPtInfoState(e.toString());
      }
    }
  }
}
