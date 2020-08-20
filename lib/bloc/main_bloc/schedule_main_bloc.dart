import 'package:anzer_schedule_app/network/model/app_info_model.dart';
import 'package:anzer_schedule_app/network/model/available_time_model.dart';
import 'package:anzer_schedule_app/network/model/doc_service_model.dart';
import 'package:anzer_schedule_app/network/model/doctor_model.dart';
import 'package:anzer_schedule_app/network/model/pt_info.dart';
import 'package:anzer_schedule_app/util/constants.dart';
import 'package:rxdart/rxdart.dart';

class ScheduleMainBloc {
  // Pt info model
  List<PtInfo> patientInfo = List();
  // doctor service list
  List<DocServiceModel> doctorServices = List();
  // doctor list
  List<DoctorModel> doctor = List();
  // // available time list
  // Map<DateTime, List> availableTimeList;
  // Appointment info
  AppInfoModel appInfo;
  // declare the event for avaiable time list
  Map<DateTime, List<AvailableTimeModel>> events;
  // declare list for available time for doctor
  List<AvailableTimeModel> availableTimeList;

  int currentPage = NAVIGATE_TO_REQUEST_PATIENT_INFO;

  // main pager
  final _mainPagerBehaviorSubject = PublishSubject<double>();
  Stream<double> get mainPagerStream => _mainPagerBehaviorSubject.stream;
  Sink<double> get mainPagerSink => _mainPagerBehaviorSubject.sink;

  // page navigation
  final _selectedPageBehaviorSubject = PublishSubject<int>();
  Stream<int> get pageNavigationStream => _selectedPageBehaviorSubject.stream;
  Sink<int> get pageNavigationSink => _selectedPageBehaviorSubject.sink;

  // patient info behaviour
  final _patientInfoModifiedBehaviourSubject = PublishSubject<PtInfo>();
  Stream<PtInfo> get patientListModifiedStream =>
      _patientInfoModifiedBehaviourSubject.stream.asBroadcastStream();
  Sink<PtInfo> get patientInfoListModifiedSink =>
      _patientInfoModifiedBehaviourSubject.sink;

  // save patient info behaviour
  final _savePatientInfoButtonEnableBehaviorSubject = PublishSubject<bool>();
  Stream<bool> get savePatientInfoButtonEnableStream =>
      _savePatientInfoButtonEnableBehaviorSubject.stream.asBroadcastStream();
  Sink<bool> get savePatientInfoButtonEnableSink =>
      _savePatientInfoButtonEnableBehaviorSubject.sink;

  // enable save patient info button
  enableSavePatientInfoButton(bool isEnable) {
    savePatientInfoButtonEnableSink.add(isEnable);
  }

  // save patient info behaviour
  final _saveAppointmentInfoButtonEnableBehaviorSubject =
      PublishSubject<bool>();
  Stream<bool> get saveAppInfoButtonEnableStream =>
      _saveAppointmentInfoButtonEnableBehaviorSubject.stream
          .asBroadcastStream();
  Sink<bool> get saveAppInfoButtonEnableSink =>
      _saveAppointmentInfoButtonEnableBehaviorSubject.sink;

  // enable save patient info button
  enableSaveAppInfoButton(bool isEnable) {
    saveAppInfoButtonEnableSink.add(isEnable);
  }

  // enable next button
  final _nextButtonEnableBehaviorSubject = PublishSubject<bool>();
  Stream<bool> get nextButtonEnableStream =>
      _nextButtonEnableBehaviorSubject.stream.asBroadcastStream();
  Sink<bool> get nextButtonEnableSink => _nextButtonEnableBehaviorSubject.sink;

  // enable next pag button
  enableNextPageButton(bool isEnable) {
    nextButtonEnableSink.add(isEnable);
  }

  // record first time data loaded in patient info screen
  final _isFirstTimeDataLoadedBehaviorSubject = PublishSubject<bool>();
  Stream<bool> get getIsFirstTimeDataLoadedStream =>
      _isFirstTimeDataLoadedBehaviorSubject.stream.asBroadcastStream();
  Sink<bool> get isFirstTimeDataLoadedSink =>
      _isFirstTimeDataLoadedBehaviorSubject.sink;

  // set value to isFirstTimeDataLoadedSink
  isFirstTimeDataLoaded(bool isEnable) {
    isFirstTimeDataLoadedSink.add(isEnable);
  }

  // navigation to next page if next button is enable
  navigateToNextPageIfPossible() {
    switch (currentPage) {
      case NAVIGATE_TO_REQUEST_PATIENT_INFO:
        {
          currentPage = NAVIGATE_TO_REQUEST_APPOINTMENT_INFO;
          patientInfo != null
              ? nextButtonEnableSink.add(true)
              : nextButtonEnableSink.add(false);
          appInfo != null
              ? nextButtonEnableSink.add(true)
              : nextButtonEnableSink.add(false);
          break;
        }
      case NAVIGATE_TO_REQUEST_APPOINTMENT_INFO:
        {
          appInfo != null
              ? nextButtonEnableSink.add(true)
              : nextButtonEnableSink.add(false);
          currentPage = NAVIGATE_TO_ALL_DONE_APPOINTMENT;
          print('app info > $appInfo');
          break;
        }
      default:
        {
          currentPage = NAVIGATE_TO_REQUEST_PATIENT_INFO;
          patientInfo != null
              ? nextButtonEnableSink.add(true)
              : nextButtonEnableSink.add(false);
        }
    }
    pageNavigationSink.add(currentPage);
  }

  // navigate to previous page
  navigateToPreviousPageIfPossible() {
    currentPage -= 1;
    pageNavigationSink.add(currentPage);
    switch (currentPage) {
      case NAVIGATE_TO_REQUEST_PATIENT_INFO:
        {
          currentPage = NAVIGATE_TO_REQUEST_APPOINTMENT_INFO;
          patientInfo != null
              ? nextButtonEnableSink.add(true)
              : nextButtonEnableSink.add(false);
          break;
        }
    }
  }

  dispose() {
    _mainPagerBehaviorSubject.close();
    _selectedPageBehaviorSubject.close();
    _patientInfoModifiedBehaviourSubject.close();
    _savePatientInfoButtonEnableBehaviorSubject.close();
    _nextButtonEnableBehaviorSubject.close();
    _isFirstTimeDataLoadedBehaviorSubject.close();
    _saveAppointmentInfoButtonEnableBehaviorSubject.close();
  }
}
