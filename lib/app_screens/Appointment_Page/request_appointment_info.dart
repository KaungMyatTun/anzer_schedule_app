import 'package:anzer_schedule_app/app_screens/Appointment_Page/chooseAppDateHeaderWidget.dart';
import 'package:anzer_schedule_app/app_screens/Appointment_Page/chooseAppTimeHeaderWidget.dart';
import 'package:anzer_schedule_app/bloc/main_bloc/schedule_main_bloc.dart';
import 'package:anzer_schedule_app/bloc/request_appointment_data/request_appointment_data_bloc.dart';
import 'package:anzer_schedule_app/network/model/app_info_model.dart';
import 'package:anzer_schedule_app/network/model/available_date_time_model.dart';
import 'package:anzer_schedule_app/network/model/available_time_model.dart';
import 'package:anzer_schedule_app/network/model/doc_service_model.dart';
import 'package:anzer_schedule_app/network/model/doctor_model.dart';
import 'package:anzer_schedule_app/util/HexColor.dart';
import 'package:anzer_schedule_app/util/ProgressDialog.dart';
import 'package:anzer_schedule_app/util/constants.dart';
import 'package:anzer_schedule_app/widget/drop_down_field.dart';
import 'package:anzer_schedule_app/widget/onboarding_header_text.dart';
import 'package:anzer_schedule_app/widget/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class RequestAppointmentInfo extends StatefulWidget {
  final ScheduleMainBloc bloc;
  RequestAppointmentInfo({@required this.bloc});

  @override
  _RequestAppointmentInfoState createState() => _RequestAppointmentInfoState();
}

class _RequestAppointmentInfoState extends State<RequestAppointmentInfo>
    with TickerProviderStateMixin {
  // declare controller for speciality
  TextEditingController _specialityController;
  // declare controller for doctor
  TextEditingController _doctorController;
  // declare list model for doctor service
  List<DocServiceModel> tempSpecialityList = List();
  // declare list for only service desc , pass this to drop down field
  List<String> docSpecDescTempList = List();
  // declare list model for doctor
  List<DoctorModel> tempDoctorList = List();
  // declare list for only doctor name, pass this to drop down field
  List<String> docNameTempList = List();
  // chosen speciality code from drop down field
  String _chosenSpecialityCode;
  // chosen doctor code from drop down field
  String _chosendDoctorCode;
  // chosen appointment date
  String _chosenAppDate;
  // chosen appointment time
  String _chosenAppTime;
  Map<String, dynamic> formData;
  Map<String, dynamic> formResultData;
  // declare initial doctor and speciality drop down
  _RequestAppointmentInfoState() {
    formData = {'Doctor': "", "Speciality": ""};
    formResultData = {'Chosen_Spec': "", 'Chosen_DocCode': ""};
  }
  // progress dialog
  ProgressDialog pr;
  // declare list for available time for doctor
  List<AvailableTimeModel> _availableTimeList;
  // declare the event for avaiable time list
  Map<DateTime, List<AvailableTimeModel>> _events;
  // declare the variable for events of selected date
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  // global form key for textformfield validation
  final _formKey = GlobalKey<FormState>();
  // declare dateformat
  final df = new DateFormat('MM-dd-yyyy');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // declare for all available date and time
  List<AvailableDateAndTimeModel> _allAvailableDateAndTime;
  // get today date
  DateTime _selectedDay;

  @override
  initState() {
    super.initState();
    _specialityController = TextEditingController();
    _doctorController = TextEditingController();

    // initiate the all available date and time list
    _allAvailableDateAndTime = List<AvailableDateAndTimeModel>();

    // initiate available time list
    _events = {};
    _selectedDay = DateTime.now();

    _selectedEvents = _events[_selectedDay] ?? [];
    _availableTimeList = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    _animationController.forward();

    // insert both serCode and serDesc to list
    for (int i = 0; i < widget.bloc.doctorServices.length; i++) {
      tempSpecialityList.add(DocServiceModel(
          servCode: widget.bloc.doctorServices[i].servCode,
          servDesc: widget.bloc.doctorServices[i].servDesc));
    }

    // insert only service description to docSpecTempList and pass this to drop down field
    for (int i = 0; i < tempSpecialityList.length; i++) {
      docSpecDescTempList.add(tempSpecialityList[i].servDesc);
    }

    // insert both doctor name,doctor code and doctor service to list
    for (int i = 0; i < widget.bloc.doctor.length; i++) {
      tempDoctorList.add(DoctorModel(
        docCode: widget.bloc.doctor[i].docCode,
        docName: widget.bloc.doctor[i].docName,
        docService: widget.bloc.doctor[i].docService,
      ));
    }

    // insert only doctor name to docTemplist and pass this to drop down field
    for (int i = 0; i < tempDoctorList.length; i++) {
      docNameTempList.add(tempDoctorList[i].docName);
    }
    if (widget.bloc.appInfo == null) {
      print('appointment information is null');
    } else if (widget.bloc.appInfo != null) {
      print('appointment information is not null');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _calendarController.dispose();
    _specialityController.dispose();
    _doctorController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // if(widget.bloc.appInfo == null){
    //   print('appointment information is null');
    // }else{
    //   print('appointment information is not null');
    // }

    // initialize the doctor controller
    _doctorController.text = widget.bloc.appInfo != null
        ? widget.bloc.appInfo.doctorName
        : _doctorController.text;
    // initialize the speciality controller
    _specialityController.text = widget.bloc.appInfo != null
        ? widget.bloc.appInfo.specialityName
        : _specialityController.text;

    // initialize the events if the event in bloc is not null
    widget.bloc.events != null ? _events = widget.bloc.events : _events = null;
    // initialize the selected day if the selected in bloc is not null
    widget.bloc.appInfo != null
        ? _selectedDay = DateTime.parse(widget.bloc.appInfo.appDate)
        : null;
    // initialize the available time list if the available time list is not null
    widget.bloc.availableTimeList != null
        ? _availableTimeList = widget.bloc.availableTimeList
        : _availableTimeList.clear();
    // initialize the formData and formResultData
    widget.bloc.appInfo != null
        ? formData['Speciality'] = widget.bloc.appInfo.specialityName
        : null;
    widget.bloc.appInfo != null
        ? formResultData['Chosen_Spec'] = widget.bloc.appInfo.specialityCode
        : formResultData['Chosen_Spec'] = null;
    widget.bloc.appInfo != null
        ? formData['Doctor'] = widget.bloc.appInfo.doctorName
        : null;
    widget.bloc.appInfo != null
        ? formResultData['Chosen_DocCode'] = widget.bloc.appInfo.doctorCode
        : formResultData['Chosen_DocCode'] = null;

    // initialize the chosen date and time if the chosen date and time in bloc is not null
    widget.bloc.appInfo != null
        ? _chosenAppDate = widget.bloc.appInfo.appDate
        : null;
    widget.bloc.appInfo != null
        ? _chosenAppTime = widget.bloc.appInfo.appTime
        : null;

    // add controller to listener
    _specialityController..addListener(_onSpecialityChangeController);
    _doctorController..addListener(_onDoctorChangeController);
  }

  // on change value controller for speciality
  void _onSpecialityChangeController() {
    print("done speciality change controller");
    if (_specialityController.text.isEmpty) {
      // set former chosen  specility code to null
      formResultData['Chosen_Spec'] = "";
      // set former chosen speciality name to null
      formData['Speciality'] = "";
      // filter doctor list again
      _makeFilterDoctorList();
      // clear doctor text
      _doctorController.text = "";
    }
  }

  // on change value for doctor controller
  void _onDoctorChangeController() {
    if (_doctorController.text.isEmpty || _doctorController.text == null) {
      // set former chosen doctor code to null
      formResultData['Chosen_DocCode'] = "";
      // set former chosen doctor name to null
      formData['Doctor'] = "";
      // set available time and selected available time when the doctor is empty
      setState(() {
        _events = {};
        _availableTimeList = [];
        // clear former chosen app date and time
        _chosenAppDate = null;
        _chosenAppTime = null;
        widget.bloc.appInfo = null;
        widget.bloc.events = null;
        widget.bloc.availableTimeList = null;
      });
    }
    // enable save button
    _enableAppSaveButton();
  }

  @override
  Widget build(BuildContext context) {
    // initiate the progress dialog
    pr = ProgressDialog(context,
        showLogs: true,
        isDismissible: false,
        customBody: SizedBox(
          width: 50,
          height: 50,
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CupertinoActivityIndicator(),
                SizedBox(
                  width: 10,
                ),
                Text('Loading')
              ],
            ),
          ),
        ));
    return BlocListener<RequestAppointmentDataBloc,
        RequestAppointmentDataState>(
      listener: (context, state) {
        // change speciality state
        if (state is LoadingChangeSpecialityState) {
          // to show progress dialog
          _showProgressDialog();
          // make filter doctor List based on choosen speciality
          _makeFilterDoctorList();
        }
        if (state is DidChangeSpecialityState) {
          // hide progress dialog
          Future.delayed(Duration(milliseconds: 700)).then((_) {
            _hideProgressDialog();
          });
        }
        // getting doctor schedule state
        if (state is LoadingGetDoctorScheduleState) {
          // to show progress dialog
          _showProgressDialog();
          // clear all former selected date
          _events.clear();
          _chosenAppDate = null;
          // clear all former selected time
          _availableTimeList.clear();
          _chosenAppTime = null;
        }
        if (state is LoadedGetDoctorScheduleState) {
          print(state.avaialbleDateAndTime.length.toString());
          // insert all available date and time
          _allAvailableDateAndTime = state.avaialbleDateAndTime;
          // filter the result of available date and time by date
          _filerAvaDateAndTimeByDate(state.avaialbleDateAndTime);
          // to hide progress dialog
          Future.delayed(Duration(milliseconds: 300)).then((_) {
            // _hideProgressDialog();
            pr.hide();
          });
        }
        if (state is ErrorGetDoctorScheduleState) {}
      },
      child:
          BlocBuilder<RequestAppointmentDataBloc, RequestAppointmentDataState>(
        builder: (context, state) {
          return _buildRequestAppointmentDataWidget();
        },
      ),
    );
  }

  // build request appointment data widget
  Widget _buildRequestAppointmentDataWidget() {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 50),
          child: Column(
            children: <Widget>[
              // appointment for title
              Row(
                children: <Widget>[
                  OnBoardingHeaderText(
                    text: 'About Appointment Detail',
                  )
                ],
              ),
              // patient given name
              SizedBox(
                height: 20,
              ),
              DropDownField(
                controller: _specialityController,
                value: formData['Speciality'],
                icon:
                    Icon(Icons.label_important, color: HexColor(PRIMARY_COLOR)),
                items: docSpecDescTempList,
                labelText: 'Speciality',
                strict: true,
                onValueChanged: (dynamic value) {
                  print('value change in speciality > $value');
                  // get result of chosen speciality code
                  for (int i = 0; i < tempSpecialityList.length; i++) {
                    if (tempSpecialityList[i].servDesc == value) {
                      _chosenSpecialityCode = "";
                      _chosenSpecialityCode = tempSpecialityList[i].servCode;
                    }
                  }
                  // insert speciality code
                  formResultData['Chosen_Spec'] = _chosenSpecialityCode;
                  // insert speciality name
                  formData['Speciality'] = value;
                  // clear former chosen doctor from doctor drop down field
                  _doctorController.text = "";
                  // provide change speciality
                  BlocProvider.of<RequestAppointmentDataBloc>(context)
                    ..add(ChangeSpecialityEvent());
                },
                setter: (dynamic newValue) {
                  formData['Sepciality'] = newValue;
                },
              ),
              SizedBox(
                height: 10,
              ),
              DropDownField(
                controller: _doctorController,
                // value: formData["Doctor"],
                icon: Icon(Icons.person, color: HexColor(PRIMARY_COLOR)),
                items: docNameTempList,
                labelText: 'Doctor',
                setter: (dynamic newValue) {
                  formData['Doctor'] = newValue;
                },
                onValueChanged: (dynamic value) {
                  // get result of doctor drop down
                  for (int i = 0; i < tempDoctorList.length; i++) {
                    if (tempDoctorList[i].docName == value) {
                      _chosendDoctorCode = "";
                      _chosendDoctorCode = tempDoctorList[i].docCode;
                    }
                  }
                  // insert chosen doctor code
                  formResultData['Chosen_DocCode'] = _chosendDoctorCode;

                  // insert chosen doctor name
                  formData['Doctor'] = value;
                  // provide for getting doctor schedule event
                  BlocProvider.of<RequestAppointmentDataBloc>(context)
                    ..add(GetDoctorScheduleEvent(
                        hospitalInst: 'AMM0000',
                        startDate: df.format(DateTime.now()),
                        endDate:
                            df.format(DateTime.now().add(Duration(days: 90))),
                        deptCode: '0016',
                        resType: 'D',
                        docCode: _chosendDoctorCode));
                },
              ),
              // choose available appointment date header
              ChooseAppDateHeader(),
              _buildTableCalendarWithBuilders(),
              // choose available appointment time header
              ChooseAppTimeHeader(),
              // available appointment time list widget
              _buildAvailableAppTime(_availableTimeList),
              StreamBuilder<bool>(
                  stream: widget.bloc.saveAppInfoButtonEnableStream,
                  builder: (context, snapshot) {
                    bool isEnable = snapshot.hasData ? snapshot.data : false;
                    print('enable save app $isEnable');
                    return RoundedButton(
                      text: 'Save',
                      colorString: PRIMARY_COLOR,
                      onPressed: isEnable ? _saveAppointmentInfo : null,
                    );
                  }),
            ],
          ),
        ),
      )),
    );
  }

  // build calendar widget
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'EN',
      initialSelectedDay: _selectedDay,
      calendarController: _calendarController,
      events: _events,
      initialCalendarFormat: CalendarFormat.month,
      startDay: DateTime.now(),
      formatAnimation: FormatAnimation.slide,
      availableGestures: AvailableGestures.horizontalSwipe,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekdayStyle: TextStyle().copyWith(color: HexColor(BLACK_COLOR)),
        weekendStyle:
            TextStyle().copyWith(color: Theme.of(context).accentColor),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle:
            TextStyle().copyWith(color: Theme.of(context).accentColor),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
        leftChevronIcon: Icon(
          Icons.keyboard_arrow_left,
          color: HexColor(PRIMARY_COLOR),
        ),
        rightChevronIcon: Icon(
          Icons.keyboard_arrow_right,
          color: HexColor(PRIMARY_COLOR),
        ),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: HexColor(PRIMARY_COLOR)),
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: HexColor(PRIMARY_COLOR)),
              width: 100,
              height: 100,
              child: Center(
                child: Text(
                  '${date.day}',
                  style:
                      TextStyle(color: Colors.white).copyWith(fontSize: 16.0),
                ),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.grey[400]),
            width: 100,
            height: 100,
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }
          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  // build available appointment time widget
  _buildAvailableAppTime(List<AvailableTimeModel> availableTimeList) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Container(
        height: 49,
        child: availableTimeList.isNotEmpty
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: availableTimeList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.all(6),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          // set false to all items of availabletime list
                          for (var index in availableTimeList) {
                            index.isSelected = false;
                          }
                          availableTimeList[index].isSelected =
                              !availableTimeList[index].isSelected;

                          // set chosen appoitment time
                          _chosenAppTime = availableTimeList[index].startTime;

                          // validate form
                          _enableAppSaveButton();
                        });
                        print(availableTimeList[index].startTime);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: _availableTimeList[index].isSelected
                                ? Colors.blueGrey
                                : Colors.white,
                            borderRadius: BorderRadius.circular(7.0),
                            border: Border.all(
                                color: Theme.of(context).accentColor)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(availableTimeList[index].startTime)),
                        ),
                      ),
                    ),
                  );
                })
            : Center(
                child: Text('No Schedule'),
              ),
      ),
    );
  }

  // build event marker
  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: _calendarController.isSelected(date)
            ? BoxShape.circle
            : BoxShape.circle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? HexColor(PRIMARY_COLOR)
                : HexColor(PRIMARY_COLOR),
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Icon(
          Icons.done,
          color: Colors.white,
          size: 10,
        ),
      ),
    );
  }

  // make doctor list filter based on choosen speciality
  _makeFilterDoctorList() {
    if (formResultData['Chosen_Spec'] != "") {
      print(formResultData['Chosen_Spec']);

      // first clear doc name temp list
      docNameTempList.clear();
      // filter doc name based on chosen speciality
      for (int i = 0; i < tempDoctorList.length; i++) {
        if (tempDoctorList[i].docService == formResultData['Chosen_Spec']) {
          docNameTempList.add(tempDoctorList[i].docName);
        }
      }
    } else if (formResultData['Chosen_Spec'] == "") {
      // first clear doctor name temp list
      docNameTempList.clear();
      // filter doctor name based on chosen speciality
      for (int i = 0; i < tempDoctorList.length; i++) {
        docNameTempList.add(tempDoctorList[i].docName);
      }
    }
  }

  // to show progress dialog
  _showProgressDialog() {
    pr.show();
  }

  // to hide progress dialog()
  _hideProgressDialog() {
    // if (mounted) {
    pr.hide();
    // }
  }

  // on day selected of calendar
  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    _availableTimeList.clear();
    setState(() {
      for (int index = 0; index < events.length; index++) {
        _availableTimeList.insert(index, events[index]);
      }
      // _availableTimeList = events;
      // _var selectedMonth = day.month < 10 ? '0${day.month}' : day.month;
      // _chosenAppDate = "${day.year}-$selectedMonth-${day.day}";
      _chosenAppDate = DateFormat('yyyy-MM-dd').format(day);
    });
    // clear former selected appointment time
    _availableTimeList.length == 0 ? _chosenAppTime = null : null;
    // validate the form
    _enableAppSaveButton();
    print('chosen date > $_chosenAppDate');
    print(DateFormat('yyyy-MM-dd').format(day));
  }

  // on visible day changed for calendar
  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  // filter the result of available date and time by date
  _filerAvaDateAndTimeByDate(List<AvailableDateAndTimeModel> avaDateAndTime) {
    var _date;
    List<AvailableTimeModel> _tempAvailableTimeList = List();
    for (int i = 0; i < avaDateAndTime.length; i++) {
      _date = avaDateAndTime[i].availableDate;
      _tempAvailableTimeList.clear();
      for (int i = 0; i < avaDateAndTime.length; i++) {
        if (avaDateAndTime[i].availableDate == _date) {
          AvailableTimeModel availableTimeModel;
          availableTimeModel = AvailableTimeModel(
              startTime: avaDateAndTime[i].opdStartTime,
              endTime: avaDateAndTime[i].opdEndTime,
              isSelected: false);
          _tempAvailableTimeList.add(availableTimeModel);
        }
      }
      setState(() {
        _events[DateTime.parse(_date)] = _tempAvailableTimeList;
      });
    }
  }

  // enable save button
  _enableAppSaveButton() {
    if (_doctorController.text.length > 0 &&
        _chosenAppDate != null &&
        _chosenAppTime != null) {
      print("enable save button done");
      widget.bloc.enableSaveAppInfoButton(true);
      widget.bloc.enableNextPageButton(false);
    } else {
      widget.bloc.enableSaveAppInfoButton(false);
      widget.bloc.enableNextPageButton(false);
    }
  }

  // save appointment info
  _saveAppointmentInfo() {
    if (_doctorController.text.length > 0 && _chosenAppDate != null) {
      // create appointment model that was chosen by user
      AppInfoModel appInfoModel = AppInfoModel(
          specialityName: formData['Speciality'],
          specialityCode: formResultData['Chosen_Spec'],
          doctorName: formData['Doctor'],
          doctorCode: formResultData['Chosen_DocCode'],
          appDate: _chosenAppDate,
          appTime: _chosenAppTime);
      // insert created app model to bloc
      widget.bloc.appInfo = appInfoModel;

      // save latest events list to bloc
      widget.bloc.events = _events;

      // save latest available time to bloc
      widget.bloc.availableTimeList = _availableTimeList;

      if (widget.bloc.appInfo != null) {
        print("********");
        print("Saved Speciality name > ${widget.bloc.appInfo.specialityName}");
        print("Saved Speciality code > ${widget.bloc.appInfo.specialityCode}");
        print("Saved doctor name > ${widget.bloc.appInfo.doctorName}");
        print("Saved doctor name > ${widget.bloc.appInfo.doctorCode}");
        print("Saved appointment date > ${widget.bloc.appInfo.appDate}");
        print("Saved appointment date > ${widget.bloc.appInfo.appTime}");
        print("********");
        widget.bloc.enableSaveAppInfoButton(false);
        widget.bloc.enableNextPageButton(true);

        print(DateFormat('yyyy-mm-dd')
            .parse(widget.bloc.appInfo.appDate)
            .day
            .toString());
        print(DateFormat('yyyy-mm-dd')
            .parse(widget.bloc.appInfo.appDate)
            .year
            .toString());
        // print(DateFormat('yyyy-MMM-dd').parse(widget.bloc.appInfo.appDate).month.toString());
      } else {
        widget.bloc.enableNextPageButton(false);
      }
    }
  }
}
