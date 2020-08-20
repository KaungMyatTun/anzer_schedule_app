part of 'request_appointment_data_bloc.dart';

@immutable
abstract class RequestAppointmentDataState {}

class RequestAppointmentDataInitial extends RequestAppointmentDataState {}

// states for getting pre required data
class LoadingGetPreRequiredDataState extends RequestAppointmentDataState {}

class LoadedGetPreRequiredDataState extends RequestAppointmentDataState {
  final List<DocServiceModel> docService;
  final List<DoctorModel> doctor;
  LoadedGetPreRequiredDataState({this.docService, this.doctor});
}

class ErrorGetPreRequiredDataState extends RequestAppointmentDataState {
  final String error;
  ErrorGetPreRequiredDataState(this.error);
}

// states for changing speciality
class LoadingChangeSpecialityState extends RequestAppointmentDataState {}

class DidChangeSpecialityState extends RequestAppointmentDataState {}

// states for changing getting doctor schedule
class LoadingGetDoctorScheduleState extends RequestAppointmentDataState {}

class LoadedGetDoctorScheduleState extends RequestAppointmentDataState {
  final List<AvailableDateAndTimeModel> avaialbleDateAndTime;
  LoadedGetDoctorScheduleState({@required this.avaialbleDateAndTime});
}

class ErrorGetDoctorScheduleState extends RequestAppointmentDataState {
  final String error;
  ErrorGetDoctorScheduleState(this.error);
}
