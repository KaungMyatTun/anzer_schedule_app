part of 'request_verify_otp_bloc.dart';

@immutable
abstract class RequestVerifyOtpEvent {}

class GetOTPEvent extends RequestVerifyOtpEvent {
  final String cpi;
  GetOTPEvent({@required this.cpi}) : assert(cpi != null);
}

class VerifyOTPEvent extends RequestVerifyOtpEvent {
  final String cpi;
  final String otpCode;
  VerifyOTPEvent({@required this.cpi, @required this.otpCode})
      : assert(cpi != null, otpCode != null);
}

class GetPtInfoEvent extends RequestVerifyOtpEvent{
  final String cpi;
  GetPtInfoEvent({@required this.cpi}) : assert(cpi != null);
}
