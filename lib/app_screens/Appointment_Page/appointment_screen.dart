import 'package:anzer_schedule_app/app_screens/Appointment_Page/all_done_appointment.dart';
import 'package:anzer_schedule_app/app_screens/Appointment_Page/request_appointment_info.dart';
import 'package:anzer_schedule_app/app_screens/Appointment_Page/request_patient_info.dart';
import 'package:anzer_schedule_app/bloc/main_bloc/schedule_main_bloc.dart';
import 'package:anzer_schedule_app/widget/next_page_button.dart';
import 'package:anzer_schedule_app/widget/page_indicator.dart';
import 'package:anzer_schedule_app/widget/previous_page_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentScreen extends StatefulWidget {
  final ScheduleMainBloc bloc;
  AppointmentScreen({@required this.bloc}) : assert(bloc != null);

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  // page controller for viewpage
  PageController _pageController;

  // to declare scaffold key
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future _navigateToPage(int page) async {
    if (_pageController.hasClients) {
      print('page number > $page');
      _pageController.animateToPage(page,
          duration: Duration(milliseconds: 300), curve: Curves.linear);
      setState(() {
        widget.bloc.currentPage = page;
      });
    } else {
      print('no child');
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 1.0);
    widget.bloc.pageNavigationStream.listen(_navigateToPage);
  }

  @override
  void dispose() {
    super.dispose();
    // widget.bloc.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
            centerTitle: true,
            title: Container(
                width: 110,
                height: 35,
                child: Image.asset(
                  "assets/anzer_logo.png",
                  fit: BoxFit.contain,
                )),
            elevation: 0.0,
            leading: ClipRect(
              child: Material(
                shadowColor: Colors.transparent,
                color: Colors.transparent,
                child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      // on back pressed function
                      _onBackPressed();
                    }),
              ),
            )),
        body: WillPopScope(
          onWillPop: _onBackPressed1,
          child: Column(
            children: <Widget>[
              StreamBuilder<int>(
                stream: widget.bloc.pageNavigationStream,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: DotsIndicator(
                      dotsCount: 3,
                      position: snapshot.hasData ? snapshot.data : 0,
                    ),
                  );
                },
              ),
              Flexible(
                child: Container(
                    child: Stack(
                  children: <Widget>[
                    _createPager(),
                    NextPageButton(
                      bloc: widget.bloc,
                    ),
                    PreviousPageButton(
                      bloc: widget.bloc,
                    )
                  ],
                )),
              )
            ],
          ),
        ));
  }

  // create view page request patient info page, request appointment info page, all done appointment page
  _createPager() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollUpdateNotification) {
          if (mounted) widget.bloc.mainPagerSink.add(_pageController.page);
        }
        return true;
      },
      child: PageView(
        onPageChanged: (pos) {
          widget.bloc.pageNavigationSink.add(pos);
          widget.bloc.currentPage = pos;
        },
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        controller: _pageController,
        children: <Widget>[
          RequestPatientInfo(bloc: widget.bloc),
          RequestAppointmentInfo(bloc: widget.bloc),
          AllDoneAppointment(bloc: widget.bloc),
        ],
      ),
    );
  }

  // ------------------------ onBackPressed function ------------------------------------
  Future<bool> _onBackPressed1() {
    return _exitApp1(context) ?? false;
  }

  // ------------------------------- logout function ----------------------------------
  _exitApp1(BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
          content: Text(
            'Are you sure to back?',
            style: TextStyle(color: Theme.of(context).primaryColor),
            textScaleFactor: 1.2,
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
              label: 'OK',
              textColor: Colors.red,
              onPressed: () {
                // navigate to previous page
                Navigator.pop(context);
                // // clean the appointment info
                // widget.bloc.appInfo = null;
                // // clean the doctor list and service list
                // widget.bloc.doctor.clear();
                // widget.bloc.doctorServices.clear();
                // // clean available time list
                // widget.bloc.availableTimeList.clear();
                // widget.bloc.events.clear();

                // clean the patient info
                widget.bloc.patientInfo != null
                    ? widget.bloc.patientInfo.clear()
                    : null;
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
              })),
    );
  }

  // ------------------------ onBackPressed function ------------------------------------
  bool _onBackPressed() {
    bool isBack;
    _exitApp(context) ? isBack = true : isBack = false;
    return isBack;
  }

  // ------------------------------- logout function ----------------------------------
  bool _exitApp(BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
          content: Text(
            'Are you sure to back?',
            style: TextStyle(color: Theme.of(context).primaryColor),
            textScaleFactor: 1.2,
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
              label: 'OK',
              textColor: Colors.red,
              onPressed: () {
                // navigate to previous page
                Navigator.pop(context);
                // clean the patient info
                widget.bloc.patientInfo != null
                    ? widget.bloc.patientInfo.clear()
                    : null;
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
              })),
    );
    return true;
  }
}
