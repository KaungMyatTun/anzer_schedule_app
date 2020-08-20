part of 'request_verify_otp_bloc.dart';

@immutable
abstract class RequestVerifyOtpState {}

class RequestVerifyOtpInitial extends RequestVerifyOtpState {}

// get one time password
class LoadingGetOTPState extends RequestVerifyOtpState {}

class LoadedGetOTPState extends RequestVerifyOtpState {
  final OTPModel otpModel;
  LoadedGetOTPState({this.otpModel});
}

class ErrorGetOTPState extends RequestVerifyOtpState {
  final String error;
  ErrorGetOTPState(this.error);
}

// verify one time password
class LoadingVerifyOTPState extends RequestVerifyOtpState {}

class LoadedVerifyOTPState extends RequestVerifyOtpState {}

class ErrorVerifyOTPState extends RequestVerifyOtpState {
  final String error;
  ErrorVerifyOTPState(this.error);
}

// get patient info
class LoadingPtInfoState extends RequestVerifyOtpState {}

class LoadedPtInfoState extends RequestVerifyOtpState {
  final PtInfo ptInfo;
  LoadedPtInfoState({this.ptInfo});
}

class ErrorPtInfoState extends RequestVerifyOtpState {
  final String error;
  ErrorPtInfoState(this.error);
}
