import 'package:anzer_schedule_app/bloc/allDone_page/alldone_page_bloc.dart';
import 'package:anzer_schedule_app/bloc/main_bloc/schedule_main_bloc.dart';
import 'package:anzer_schedule_app/network/model/submit_app_model.dart';
import 'package:anzer_schedule_app/util/AlertDialogManager.dart';
import 'package:anzer_schedule_app/util/HexColor.dart';
import 'package:anzer_schedule_app/util/ProgressDialog.dart';
import 'package:anzer_schedule_app/util/constants.dart';
import 'package:anzer_schedule_app/widget/onboarding_header_text.dart';
import 'package:anzer_schedule_app/widget/rounded_button.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AllDoneAppointment extends StatefulWidget {
  final ScheduleMainBloc bloc;
  AllDoneAppointment({this.bloc});

  @override
  _AllDoneAppointmentState createState() => _AllDoneAppointmentState();
}

class _AllDoneAppointmentState extends State<AllDoneAppointment> {
  // to get only time from datetime string
  String _onlyTime;
  // to get only time type (PM, AM) from date time string
  String _timeType;
  // progress dialog
  ProgressDialog pr;
  // error message
  String _error;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // call loading
    pr = ProgressDialog(context,
        showLogs: true,
        isDismissible: false,
        customBody: Container(
          width: 100,
          height: 50,
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
        ));
    widget.bloc.appInfo != null
        ? _formatTime(DateFormat.jm()
            .format(DateFormat.Hm().parse(widget.bloc.appInfo.appTime)))
        : null;
    // return widget.bloc.patientInfo != null && widget.bloc.appInfo != null
    //     ? _buildAllDoneWidget()
    //     : Container();
    return BlocListener<AlldonePageBloc, AlldonePageState>(
      listener: (context, state) async {
        if (state is LoadingSubmitAppState) {
          print("Loading submit app state");
          setState(() {
            pr.show();
          });
        }
        if (state is LoadedSumbitAppState) {
          Future.delayed(Duration(seconds: 1)).then((_) {
            setState(() {
              pr.hide();
              _buildMakingAppDoneWidget();
            });
          });
        }
        if (state is ErrorSubmitAppState) {
          if (state.error.contains("SocketException")) {
            setState(() {
              _error = "Oops! Check your internet.";
            });
          } else {
            setState(() {
              _error = "Oops! Something wrong.";
            });
          }
          setState(() {
            pr.hide();
            AlertDialogManager.awesomeErrorDialog(
                _scaffoldKey.currentContext, "Error", _error);
          });
        }
      },
      child: BlocBuilder<AlldonePageBloc, AlldonePageState>(
        builder: (context, state) {
          return widget.bloc.patientInfo != null && widget.bloc.appInfo != null
              ? _buildAllDoneWidget()
              : Container();
        },
      ),
    );
  }

  // build all done page widget()
  _buildAllDoneWidget() {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 50),
          child: Column(
            children: <Widget>[
              // preview appointment title
              Row(
                children: <Widget>[
                  OnBoardingHeaderText(
                    text: 'Preview Appointment',
                  )
                ],
              ),
              // patient given name
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 3.0,
                  color: HexColor('#ffffff'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Appointment with,',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        widget.bloc.appInfo != null
                            ? Text(
                                widget.bloc.appInfo.doctorName,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            : Text(
                                '-',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                        widget.bloc.appInfo.specialityName != ""
                            ? Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  '[${widget.bloc.appInfo.specialityName}]',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text('Appointment Date and Time',
                              style: TextStyle(fontSize: 18)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              height: 100,
                              child: Card(
                                elevation: 3.0,
                                color: HexColor(PRIMARY_COLOR),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: HexColor(BLACK_COLOR),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    widget.bloc.appInfo != null
                                        ? Text(
                                            DateFormat('yyyy-MM-dd')
                                                .parse(
                                                    widget.bloc.appInfo.appDate)
                                                .day
                                                .toString(),
                                            style: TextStyle(
                                                color: HexColor(WHITE_COLOR),
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            '-',
                                            style: TextStyle(
                                                color: HexColor(WHITE_COLOR),
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                    widget.bloc.appInfo != null
                                        ? Text(
                                            '${DateFormat.MMMM().format(DateTime.parse(widget.bloc.appInfo.appDate))} , ${DateTime.parse(widget.bloc.appInfo.appDate).year.toString()}',
                                            style: TextStyle(
                                                color: HexColor(WHITE_COLOR)),
                                          )
                                        : Text(
                                            '-',
                                            style: TextStyle(
                                                color: HexColor(WHITE_COLOR)),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              height: 100,
                              child: Card(
                                elevation: 3.0,
                                color: HexColor(PRIMARY_COLOR),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: HexColor(BLACK_COLOR),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Center(
                                      child: widget.bloc.appInfo != null
                                          ? Text(
                                              _onlyTime,
                                              style: TextStyle(
                                                  color: HexColor(WHITE_COLOR),
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(
                                              '-',
                                              style: TextStyle(
                                                  color: HexColor(WHITE_COLOR),
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ),
                                    widget.bloc.appInfo != null
                                        ? Text(
                                            _timeType,
                                            style: TextStyle(
                                                color: HexColor(WHITE_COLOR)),
                                          )
                                        : Text(
                                            '-',
                                            style: TextStyle(
                                                color: HexColor(WHITE_COLOR)),
                                          ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text('Patient Information',
                              style: TextStyle(fontSize: 18)),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            margin: EdgeInsets.all(10),
                            elevation: 3.0,
                            color: HexColor('#ffffff'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: HexColor(BLACK_COLOR),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child:
                                                widget.bloc.patientInfo != null
                                                    ? Text(
                                                        '${widget.bloc.patientInfo[0].ptGivenName} ${widget.bloc.patientInfo[0].ptSurname}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16),
                                                      )
                                                    : Text(
                                                        '-',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16),
                                                      )),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.phone,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:
                                              widget.bloc.patientInfo[0] != null
                                                  ? Text(
                                                      widget.bloc.patientInfo[0]
                                                          .ptMobilePhone,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                    )
                                                  : Text(
                                                      '-',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                    ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.person_pin_circle,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:
                                              widget.bloc.patientInfo[0] != null
                                                  ? Text(
                                                      widget.bloc.patientInfo[0]
                                                          .ptAddress,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                      softWrap: true,
                                                    )
                                                  : Text(
                                                      '-',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                      softWrap: true,
                                                    ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),
              Container(
                child: RoundedButton(
                  onPressed: () {
                    SubmitAppModel appModel = SubmitAppModel(
                        ptCPI: widget.bloc.patientInfo[0].ptCpi,
                        ptGivenName: widget.bloc.patientInfo[0].ptGivenName,
                        ptSurname: widget.bloc.patientInfo[0].ptSurname,
                        ptDoB: widget.bloc.patientInfo[0].ptDob,
                        ptDoD: widget.bloc.patientInfo[0].ptDod,
                        ptAge: widget.bloc.patientInfo[0].ptAge.toString(),
                        ptSex: widget.bloc.patientInfo[0].ptSex,
                        ptMobileNumber:
                            widget.bloc.patientInfo[0].ptMobilePhone,
                        ptAddress: widget.bloc.patientInfo[0].ptAddress,
                        specialityName: widget.bloc.appInfo.specialityName == ""
                            ? null
                            : widget.bloc.appInfo.specialityName,
                        specialityCode: widget.bloc.appInfo.specialityCode == ""
                            ? null
                            : widget.bloc.appInfo.specialityCode,
                        doctorName: widget.bloc.appInfo.doctorName,
                        doctorCode: widget.bloc.appInfo.doctorCode,
                        appdate: widget.bloc.appInfo.appDate,
                        appTime: widget.bloc.appInfo.appTime,
                        requestDTApp: DateTime.now());

                    // provide submit app event
                    BlocProvider.of<AlldonePageBloc>(context)
                      ..add(SubmitAppEvent(appModel: appModel));
                  },
                  text: 'Submit',
                  colorString: PRIMARY_COLOR,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // format the time
  _formatTime(String _inputTime) {
    String newString = _inputTime.substring(0, _inputTime.length - 2);
    _onlyTime = newString;
    _timeType = _inputTime.substring(_inputTime.length - 2);
  }

  // build verification successful widget
  _buildMakingAppDoneWidget() {
    AwesomeDialog(
            context: context,
            keyboardAware: true,
            dismissOnBackKeyPress: false,
            dialogType: DialogType.SUCCES,
            animType: AnimType.BOTTOMSLIDE,
            padding: const EdgeInsets.all(16.0),
            body: Column(
              children: [
                Center(
                    child: Text(
                  'Appointment Done.',
                  textScaleFactor: 1.5,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                SizedBox(height: 10,),
                Text(
                    'You may be contacted by Hospital site regarding with appointment confirmation.', textAlign: TextAlign.justify,),
                SizedBox(
                  height: 20,
                ),
                RoundedButton(
                  text: 'OK',
                  onPressed: () {
                    _cleanFinishedData();
                    Navigator.pop(context);
                    Navigator.of(context).pop();
                  },
                  colorString: PRIMARY_COLOR,
                ),
              ],
            ),
            btnOkColor: HexColor(PRIMARY_COLOR))
        .show();
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) {
    //       return StatefulBuilder(
    //         builder: (context, StateSetter setState) {
    //           return WillPopScope(
    //               onWillPop: () async => false,
    //               child: Dialog(
    //                 shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.all(Radius.circular(20))),
    //                 child: Container(
    //                   width: 100,
    //                   height: 300,
    //                   child: Column(
    //                     children: <Widget>[
    //                       Container(
    //                           margin: EdgeInsets.only(top: 20),
    //                           height: 100,
    //                           width: 100,
    //                           child: Image.asset(
    //                               "assets/verification_successful.gif")),
    //                       Padding(
    //                         padding: const EdgeInsets.all(8.0),
    //                         child: Text(
    //                           'You may be contacted by Hospital site regarding with appointment confirmation.',
    //                           textScaleFactor: 1.2,
    //                           textAlign: TextAlign.justify,
    //                         ),
    //                       ),
    //                       SizedBox(
    //                         height: 30,
    //                       ),
    //                       RoundedButton(
    //                         text: 'OK',
    //                         onPressed: () {
    //                           _cleanFinishedData();
    //                           Navigator.pop(context);
    //                           Navigator.of(context).pop();
    //                           // Navigator.of(context).push(
    //                           //     CupertinoPageRoute<Null>(
    //                           //         builder: (BuildContext context) {
    //                           //   return HomePage();
    //                           // }));
    //                         },
    //                         colorString: PRIMARY_COLOR,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ));
    //         },
    //       );
    //     });
  }

  _cleanFinishedData() {
    // clean the patient info
    widget.bloc.patientInfo != null ? widget.bloc.patientInfo.clear() : null;
    // clean the appointment info
    widget.bloc.appInfo != null ? widget.bloc.appInfo = null : null;
    // clean the events from bloc
    widget.bloc.events != null ? widget.bloc.events = {} : null;
    // clean the available time list
    widget.bloc.availableTimeList != null
        ? widget.bloc.availableTimeList.clear()
        : null;
    // set the page as 0
    setState(() {
      widget.bloc.currentPage = 0;
    });
  }
}
