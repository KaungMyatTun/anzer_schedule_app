part of 'appointment_page_bloc.dart';

@immutable
abstract class AppointmentPageState {}

class AppointmentPageInitial extends AppointmentPageState {}

class LoadingSetPatientInfoState extends AppointmentPageState {}

class LoadedSetPatientInfoState extends AppointmentPageState {}

class LoadingChangeSpecialityState extends AppointmentPageState {}

class DidChangeSpecialityState extends AppointmentPageState {}
