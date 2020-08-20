part of 'request_appointment_data_bloc.dart';

@immutable
abstract class RequestAppointmentDataEvent {}

class GetPreRequiredData extends RequestAppointmentDataEvent {}

class ChangeSpecialityEvent extends RequestAppointmentDataEvent {}

class GetDoctorScheduleEvent extends RequestAppointmentDataEvent {
  final String hospitalInst;
  final String startDate;
  final String endDate;
  final String deptCode;
  final String resType;
  final String docCode;

  GetDoctorScheduleEvent(
      {@required this.hospitalInst,
      @required this.startDate,
      @required this.endDate,
      @required this.deptCode,
      @required this.resType,
      @required this.docCode});
}
