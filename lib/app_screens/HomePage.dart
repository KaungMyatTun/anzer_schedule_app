import 'package:anzer_schedule_app/app_screens/Appointment_Page/appointment_screen.dart';
import 'package:anzer_schedule_app/app_screens/CPI_Request_Page/cpi_request_page.dart';
import 'package:anzer_schedule_app/app_screens/TeleMedicine_Page/teleMedicine_page.dart';
import 'package:anzer_schedule_app/bloc/home_page/home_page_bloc.dart';
import 'package:anzer_schedule_app/bloc/main_bloc/schedule_main_bloc.dart';
import 'package:anzer_schedule_app/util/HexColor.dart';
import 'package:anzer_schedule_app/util/constants.dart';
import 'package:anzer_schedule_app/widget/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:retrofit/dio.dart';

class HomePage extends KFDrawerContent {
  // HomePage({Key key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // to show snackbar
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScheduleMainBloc _bloc;
  bool _isLoading;
  bool _YesOrNoBtn; // true = yes btn clicked, false = no btn clicked
  AppBar appBar;
  String _errorMsg;
  HomePage hmp;

  @override
  void initState() {
    super.initState();
    _bloc = ScheduleMainBloc();
    _isLoading = false;
    hmp = HomePage();
  }

  @override
  Widget build(BuildContext context) {
    // build app bar
    appBar = AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: ClipRect(
        child: Material(
          shadowColor: Colors.transparent,
          color: Colors.transparent,
          child: IconButton(
            icon: Icon(
              Icons.menu,
              color: HexColor(PRIMARY_COLOR),
            ),
            onPressed: () {
              widget.onMenuPressed();
            },
          ),
        ),
      ),
      centerTitle: true,
      actions: <Widget>[
        ClipRect(
            child: Material(
          shadowColor: Colors.transparent,
          color: Colors.transparent,
          child: FlatButton(
            child: Icon(Icons.feedback, color: HexColor(PRIMARY_COLOR)),
            onPressed: () {},
          ),
        ))
      ],
    );

    return Scaffold(
        key: _scaffoldKey,
        appBar: appBar,
        backgroundColor: Colors.white,
        body: WillPopScope(
          onWillPop: _onBackPressed,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: BlocListener<HomePageBloc, HomePageState>(
                    listener: (context, state) {
                      if (state is LoadingGetPreRequiredDataState) {
                        setState(() {
                          _isLoading = true;
                          _errorMsg = null;
                        });
                      }
                      if (state is LoadedGetPreRequiredDataState) {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                            _errorMsg = null;
                            _bloc.doctorServices = state.docService;
                            _bloc.doctor = state.doctor;
                          });
                        }
                        _YesOrNoBtn
                            ? _openCPIRequestPage()
                            : _openAppointmentPage();
                      }
                      if (state is ErrorGetPreRequiredDataState) {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                        if (state.error.contains("Socket")) {
                          _errorMsg =
                              "Oops! Please check your internet connection";
                        } else {
                          _errorMsg =
                              "Oops! Something wrong. Please try again.";
                        }
                      }
                    },
                    child: BlocBuilder<HomePageBloc, HomePageState>(
                      builder: (context, state) {
                        return _setUpHomePage();
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  // build page route to appointment page
  _openAppointmentPage() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context)
          .push(CupertinoPageRoute<Null>(builder: (BuildContext context) {
        return AppointmentScreen(
          bloc: _bloc,
        );
      }));
    });
  }

  // build page route to CPI request page
  _openCPIRequestPage() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context)
          .push(CupertinoPageRoute<Null>(builder: (BuildContext context) {
        return CPIReqeuestPage(bloc: _bloc);
      }));
    });
  }

  // ------------------------ setup home page ----------------------------
  Widget _setUpHomePage() {
    return ListView(
      children: <Widget>[
        Container(
          width: 120,
          height: 70,
          margin: EdgeInsets.only(top: 20),
          child: Image.asset("assets/anzer_logo.png"),
        ),
        Center(
            child: Text(
          'Anzer Hospital',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 0.5),
        )),
        SizedBox(
          height: 5,
        ),
        Center(
            child: Text(
          'Patient Scheduling',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        )),
        // SizedBox(height: MediaQuery.of(context).size.height / 4),
        SizedBox(
          height: 30,
        ),
        Center(
          child: Wrap(
            children: _buildHomePageGrid(context),
          ),
        ),
        // Center(
        //   child: Text(
        //     'Visited Anzer Hospital Before?',
        //     style: TextStyle(
        //         color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        //   ),
        // ),
        // RoundedButton(
        //   colorString: PRIMARY_COLOR,
        //   text: "Yes",
        //   onPressed: () {
        //     BlocProvider.of<HomePageBloc>(context)..add(YesEvent());
        //     setState(() {
        //       _YesOrNoBtn = true;
        //     });
        //   },
        // ),
        // // create no button
        // RoundedButton(
        //   colorString: PRIMARY_COLOR,
        //   text: "No",
        //   onPressed: () {
        //     BlocProvider.of<HomePageBloc>(context)..add(NoEvent());
        //     setState(() {
        //       _YesOrNoBtn = false;
        //     });
        //   },
        // ),
        SizedBox(
          height: 20,
        ),
        _isLoading ? CupertinoActivityIndicator() : Container(),
        _errorMsg == null
            ? Container()
            : Center(
                child: Container(
                  child: Text(
                    _errorMsg,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              )
      ],
    );
  }

  // build home page grid view
  _buildHomePageGrid(BuildContext context) {
    List<int> gridItem = [0, 1, 2, 3, 4, 5];
    List<String> gridItemName = [
      'OPD Appointment',
      'TeleMedicine',
      'Vital',
      'Patient Enquiry',
      'Lab Results',
      'DI Results'
      // 'Doctor',
      // 'Health Tips',
      // 'Others',
      // 'Others'
    ];
    List<String> gridItemImg = [
      'assets/opd_appointment.png',
      'assets/telemedicine.png',
      'assets/telemedicine.png',
      'assets/telemedicine.png',
      'assets/telemedicine.png',
      'assets/telemedicine.png',
      // 'assets/opd_appointment.png',
      // 'assets/telemedicine.png',
    ];
    List<Widget> gvCard = List();
    gridItem.forEach((item) {
      gvCard.add(Container(
        margin: EdgeInsets.only(bottom: 20, right: 5),
        width: MediaQuery.of(context).size.width / 2.8,
        height: 150,
        padding: EdgeInsets.all(5),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              side: BorderSide(color: Colors.black)),
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              print(item);
              _pageRouteofCard(item);
            },
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Image.asset(gridItemImg[item]),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                        color: HexColor(PRIMARY_COLOR),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    child: Center(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Text(
                            gridItemName[item],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    });
    return gvCard;
  }

  // build dialog when click on OPD appointment
  _askQuestionForOPDApp(BuildContext context) {
    return showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text(
              'Visited Anzer Hospital Before?',
              textScaleFactor: 1.2,
              style: TextStyle(
                color: HexColor(BLACK_COLOR),
              ),
            ),
            message: Text(
              'If you have visited ANZER hospital before, please say \'YES\'. Otherwise, please say \'No\'',
              textScaleFactor: 1,
              style: TextStyle(
                color: HexColor(BLACK_COLOR),
              ),
            ),
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                onPressed: () {
                  BlocProvider.of<HomePageBloc>(context)..add(YesEvent());
                  setState(() {
                    _YesOrNoBtn = true;
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Yes'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  BlocProvider.of<HomePageBloc>(context)..add(NoEvent());
                  setState(() {
                    _YesOrNoBtn = false;
                  });
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
            ],
          );
        });
  }

  // page route to card item clicking
  _pageRouteofCard(int cardItem) {
    switch (cardItem) {
      case 0:
        _askQuestionForOPDApp(context);
        break;
      case 1:
        {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context)
                .push(CupertinoPageRoute<Null>(builder: (BuildContext context) {
              return TeleMedicinePage();
            }));
          });
        }
        break;
    }
  }

  // ------------------------ onBackPressed function ------------------------------------
  Future<bool> _onBackPressed() {
    return _exitApp(context) ?? false;
  }

  // ------------------------------- logout function ----------------------------------
  _exitApp(BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
          content: Text('Quit'),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
              label: 'OK',
              textColor: Colors.red,
              onPressed: () {
                SystemNavigator.pop();
              })),
    );
  }
}
