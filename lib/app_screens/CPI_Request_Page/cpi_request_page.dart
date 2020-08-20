import 'package:anzer_schedule_app/app_screens/Appointment_Page/appointment_screen.dart';
import 'package:anzer_schedule_app/bloc/main_bloc/bloc_provider.dart';
import 'package:anzer_schedule_app/bloc/main_bloc/schedule_main_bloc.dart';
import 'package:anzer_schedule_app/bloc/request_verify_otp/request_verify_otp_bloc.dart';
import 'package:anzer_schedule_app/util/AlertDialogManager.dart';
import 'package:anzer_schedule_app/util/HexColor.dart';
import 'package:anzer_schedule_app/util/ProgressDialog.dart';
import 'package:anzer_schedule_app/util/constants.dart';
import 'package:anzer_schedule_app/widget/custom_text_feild_form.dart';
import 'package:anzer_schedule_app/widget/rounded_button.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:quiver/async.dart';

class CPIReqeuestPage extends StatefulWidget {
  final ScheduleMainBloc bloc;
  CPIReqeuestPage({@required this.bloc});
  @override
  _CPIReqeuestPageState createState() => _CPIReqeuestPageState();
}

class _CPIReqeuestPageState extends State<CPIReqeuestPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _cpiController;
  // app bar
  AppBar appBar;
  // progress dialog
  ProgressDialog pr;
  // start timer
  int _start = 60;
  // current time initialize
  int _current = 60;
  // text get otp button label
  String _getOTPBtnLbl = 'Get OTP';
  // verify label
  String _verificationLbl = "";
  // otp code
  String _otpCode;
  // verify start
  bool _verifyStart = false;
  // loading for getting patient information
  bool _loadingForPtInfo = false;
  // error state in getting patient information
  String _errorGettingPtInfo = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScheduleMainBloc _bloc;

  @override
  void initState() {
    super.initState();
    _cpiController = TextEditingController();
    _bloc = widget.bloc;
  }

  @override
  void dispose() {
    super.dispose();
    _cpiController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // build app bar
    appBar = AppBar(
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
                  Navigator.pop(context);
                }),
          ),
        ));
    return ScheduleMainBlocProvider(
        bloc: _bloc,
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: appBar,
            body: BlocListener<RequestVerifyOtpBloc, RequestVerifyOtpState>(
              listener: (context, state) async {
                // -------------- start get one time password ---------------- //
                if (state is LoadingGetOTPState) {
                  print("loading get otp");
                  // show progress dialog
                  pr.show();
                } else if (state is LoadedGetOTPState) {
                  // start timer
                  startTimer();
                  // set verification lable
                  if (mounted)
                    setState(() {
                      _verificationLbl =
                          "Enter 6-digits code that has sent to your mobile number ${state.otpModel.phoneNumber}. Please verify";
                    });
                  // hide progress dialog
                  if (pr.isShowing()) {
                    pr.hide();
                  }
                  // verify start
                  if (mounted) {
                    setState(() {
                      _verifyStart = true;
                    });
                  }
                  // to show alert dialog
                  String alertTitle = "OTP Code";
                  String alertContent =
                      "Your OTP code is ${state.otpModel.otpCode}";
                  EasyRichText tt = EasyRichText(
                      text: alertContent,
                      textAlign: TextAlign.center,
                      patternMap: {
                        '${state.otpModel.otpCode}': TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20)
                      });
                  // AlertDialogManager.alertGetOTPDialog(
                  //     _scaffoldKey.currentContext, alertTitle, tt);
                  AlertDialogManager.awesomeAlertDialog(
                      _scaffoldKey.currentContext, alertTitle, alertContent);
                }
                if (state is ErrorGetOTPState) {
                  // hide progress dialog
                  if (pr.isShowing()) {
                    pr.hide();
                  }
                  // set verify step false
                  if (mounted) {
                    setState(() {
                      _verifyStart = false;
                    });
                  }
                  // to show error alert dialog while getting OTP
                  if (state.error.contains('429')) {
                    String alertTitle = "Too Many Requests";
                    String alertContent =
                        "You may need to wait to do this action. Please try in later.";
                    // AlertDialogManager.alertDialog(
                    //     _scaffoldKey.currentContext, alertTitle, alertContent);
                    AlertDialogManager.awesomeErrorDialog(
                        _scaffoldKey.currentContext, alertTitle, alertContent);
                  } else if (state.error.contains('SocketException')) {
                    String alertTitle = "Oops !";
                    String alertContent =
                        "Please check your internet connection.";
                    // AlertDialogManager.alertDialog(
                    //     _scaffoldKey.currentContext, alertTitle, alertContent);
                    AlertDialogManager.awesomeErrorDialog(
                        _scaffoldKey.currentContext, alertTitle, alertContent);
                  } else {
                    String alertTitle = "Oops !";
                    String alertContent = "Something wrong. Please try again.";
                    // AlertDialogManager.alertDialog(
                    //     _scaffoldKey.currentContext, alertTitle, alertContent);
                    AlertDialogManager.awesomeErrorDialog(
                        _scaffoldKey.currentContext, alertTitle, alertContent);
                  }
                }
                // ------------------ END Get one time password --------------------- //
                // ------------------ STARt one time password verification --------------------- //
                if (state is LoadingVerifyOTPState) {
                  // to show progress dialog
                  pr.show();
                  // // start timer
                  // startTimer();
                }
                if (state is LoadedVerifyOTPState) {
                  // to hide progress dialog and go to appointment screen when verify OTP state is complete
                  pr.hide().then((value) {
                    _buildVerificationSuccessfulWidget("");
                  });
                }
                if (state is ErrorVerifyOTPState) {
                  // to hide progress dialog
                  pr.hide();
                  // to show error alert dialog while in verification OTP state
                  if (state.error.contains("404")) {
                    String alertTitle = "Oops !";
                    String alertContent = "Your OTP is wrong";
                    // AlertDialogManager.alertDialog(
                    //     _scaffoldKey.currentContext, alertTitle, alertContent);
                    AlertDialogManager.awesomeErrorDialog(
                        _scaffoldKey.currentContext, alertTitle, alertContent);
                  } else if (state.error.contains("SocketException")) {
                    String alertTitle = "Oops !";
                    String alertContent =
                        "Please check your internet connection.";
                    // AlertDialogManager.alertDialog(
                    //     _scaffoldKey.currentContext, alertTitle, alertContent);
                    AlertDialogManager.awesomeErrorDialog(
                        _scaffoldKey.currentContext, alertTitle, alertContent);
                  } else if (state.error.contains("403")) {
                    String alertTitle = "Oops !";
                    String alertContent =
                        "Your OTP is invalid. Please get another OTP.";
                    // AlertDialogManager.alertDialog(
                    //     _scaffoldKey.currentContext, alertTitle, alertContent);
                    AlertDialogManager.awesomeErrorDialog(
                        _scaffoldKey.currentContext, alertTitle, alertContent);
                  } else {
                    String alertTitle = "Oops !";
                    String alertContent = "Something wrong. Please try again.";
                    // AlertDialogManager.alertDialog(
                    //     _scaffoldKey.currentContext, alertTitle, alertContent);
                    AlertDialogManager.awesomeErrorDialog(
                        _scaffoldKey.currentContext, alertTitle, alertContent);
                  }
                }
                // ----------------------- END one time password verification ------------------------ //
                // ----------------------- START get patient info ------------------------- //
                if (state is LoadingPtInfoState) {
                  if (mounted) {
                    // setState(() {
                    //   _loadingForPtInfo = true;
                    // });
                    pr.show();
                  }
                }
                if (state is LoadedPtInfoState) {
                  // to insert patient info to provider
                  try {
                    final _bloc = ScheduleMainBlocProvider.of(context);
                    print('CPI > ${state.ptInfo.ptCpi}');
                    _bloc.patientInfo.add(state.ptInfo);
                    _bloc.patientInfoListModifiedSink.add(state.ptInfo);
                    print("length > ${_bloc.patientInfo.length}");
                  } on Exception catch (e) {
                    print(e.toString());
                    _errorGettingPtInfo = e.toString();
                    AlertDialogManager.awesomeErrorDialog(
                        _scaffoldKey.currentContext,
                        "Error",
                        _errorGettingPtInfo);
                  }
                  await Future.delayed(Duration(seconds: 1)).then((value) {
                    // to pop verification successful dialog
                    // Navigator.of(context).pop();
                    // to go Appointment screen
                    pr.hide();
                    Navigator.of(context).pushReplacement(
                        CupertinoPageRoute<Null>(
                            builder: (BuildContext context) {
                      return AppointmentScreen(
                        bloc: _bloc,
                      );
                    }));
                  });
                }
                if (state is ErrorPtInfoState) {
                  setState(() {
                    _loadingForPtInfo = false;
                    pr.hide();
                    if (state.error.contains("SocketException")) {
                      _errorGettingPtInfo = "Oops! Check your internet.";
                      AlertDialogManager.awesomeErrorDialog(
                          _scaffoldKey.currentContext,
                          "Error",
                          _errorGettingPtInfo);
                    } else {
                      _errorGettingPtInfo = "Oops! Something wrong.";
                      AlertDialogManager.awesomeErrorDialog(
                          _scaffoldKey.currentContext,
                          "Error",
                          _errorGettingPtInfo);
                    }
                  });
                  // pop navigator and rebuild verification successful widget with update message
                  // Navigator.of(context).pop();
                  // _buildVerificationSuccessfulWidget(_errorGettingPtInfo);
                }
                // ----------------------- END get patient info ---------------------- //
              },
              child: BlocBuilder<RequestVerifyOtpBloc, RequestVerifyOtpState>(
                builder: (context, state) {
                  return _setupRequestCPI();
                },
              ),
            )));
  }

  // build request cpi screen
  Widget _setupRequestCPI() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 0.0, left: 8.0, right: 8.0, bottom: 0.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height -
                    appBar.preferredSize.height -
                    (2 * MediaQuery.of(context).padding.top)),
            child: Column(
              children: <Widget>[
                _verifyStart
                    ? Container(
                        height: 100,
                        width: 150,
                        child: Image.asset("assets/sms_received.png"))
                    : Container(
                        height: 100,
                        width: 150,
                        child: Image.asset("assets/sms_send.png")),
                _verifyStart
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Enter Your Hospital Number',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                _verifyStart
                    ? Container()
                    : Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Please enter your Hospital number. We will send One Time Password to your mobile phone for hospital number verification.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                SizedBox(
                  height: 20,
                ),
                CustomTextFieldForm(
                    labelText: 'Hospital Number',
                    controller: _cpiController,
                    hintText: "Hospital Number",
                    helperText: "",
                    textInputType: TextInputType.number,
                    currentFocus: null,
                    nextFocus: null,
                    validator: (val) => val.length == 0
                        ? "Please fill your hospital number"
                        : null),
                _current == 60 && _verifyStart == false
                    ? RoundedButton(
                        colorString: PRIMARY_COLOR,
                        text: _getOTPBtnLbl,
                        onPressed: () {
                          _getOTPCode();
                        },
                      )
                    : Container(),
                _current != 60 && _verifyStart == false
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Get OTP in $_current s',
                          style: TextStyle(color: HexColor(PRIMARY_COLOR)),
                        ),
                      )
                    : Container(),
                _verifyStart
                    ? Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: HexColor(PRIMARY_COLOR),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Verification Code',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      _verificationLbl,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: PinCodeTextField(
                                    length: 6,
                                    obsecureText: false,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(5),
                                      inactiveFillColor: Colors.white,
                                      inactiveColor: Colors.white,
                                      activeFillColor: Colors.white,
                                      activeColor: Colors.white,
                                      selectedColor: Colors.black,
                                      selectedFillColor: Colors.white,
                                      fieldHeight: 50,
                                      fieldWidth: 40,
                                    ),
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                    backgroundColor: HexColor(PRIMARY_COLOR),
                                    enableActiveFill: true,
                                    onChanged: (value) {
                                      setState(() {
                                        _otpCode = value;
                                      });
                                    },
                                    beforeTextPaste: (text) {
                                      print("paste text $text");
                                      return true;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: RoundedButton(
                                    colorString: "#ffffff",
                                    text: "Verify",
                                    onPressed: () {
                                      _verifyOTPCode();
                                    },
                                  ),
                                ),
                                _current == 60
                                    ? InkWell(
                                        child: Text(
                                          _getOTPBtnLbl,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onTap: () {
                                          _getOTPCode();
                                        },
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                      )
                                    : Text('Get OTP in $_current s'),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  // build verification successful widget
  _buildVerificationSuccessfulWidget(String _error) {
    AwesomeDialog(
            context: context,
            keyboardAware: true,
            dismissOnBackKeyPress: false,
            dialogType: DialogType.SUCCES,
            animType: AnimType.BOTTOMSLIDE,
            padding: const EdgeInsets.all(16.0),
            onDissmissCallback: () {
              _loadingForPtInfo ? CupertinoActivityIndicator() : Container();
            },
            body: Column(
              children: [
                Center(
                    child: Text(
                  'Success',
                  textScaleFactor: 1.5,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                SizedBox(height: 10,),
                Text('Your OTP Verification is successful!'),
                SizedBox(
                  height: 20,
                ),
                RoundedButton(
                  text: 'Next',
                  onPressed: () {
                    _getPtInfo();
                    Navigator.pop(context);
                    // to show loading
                    // if (mounted) {
                    //   setState(() {
                    //     _loadingForPtInfo = true;
                    //     _errorGettingPtInfo = _error;
                    //     pr.show();
                    //   });
                    // }
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
    //                       Center(
    //                         child: Text(
    //                           'Verification successful !',
    //                           textScaleFactor: 1.5,
    //                         ),
    //                       ),
    //                       SizedBox(
    //                         height: 30,
    //                       ),
    //                       RoundedButton(
    //                         text: 'Next',
    //                         onPressed: () {
    //                           _getPtInfo();
    //                           // to show loading
    //                           if (mounted) {
    //                             setState(() {
    //                               _loadingForPtInfo = true;
    //                               _errorGettingPtInfo = _error;
    //                             });
    //                           }
    //                         },
    //                         colorString: PRIMARY_COLOR,
    //                       ),
    //                       _loadingForPtInfo
    //                           ? CupertinoActivityIndicator()
    //                           : Container(),
    //                       _errorGettingPtInfo != null
    //                           ? _errorGettingPtInfo != ""
    //                               ? Text(
    //                                   _errorGettingPtInfo,
    //                                   style: TextStyle(color: Colors.red),
    //                                 )
    //                               : Container()
    //                           : Container()
    //                     ],
    //                   ),
    //                 ),
    //               ));
    //         },
    //       );
    //     });
  }

  // get OTP code
  _getOTPCode() {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      // // start timer
      // startTimer();

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

      // provide get otp event
      BlocProvider.of<RequestVerifyOtpBloc>(context)
        ..add(GetOTPEvent(cpi: _cpiController.text));
      print(_cpiController.text);
    }
  }

  // verify the OTP code
  _verifyOTPCode() {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (_otpCode == null) {
        String alertTitle = "Oops !";
        String alertContent = "Your OTP is invalid.";
        // AlertDialogManager.alertDialog(
        //     _scaffoldKey.currentContext, alertTitle, alertContent);
        AlertDialogManager.awesomeErrorDialog(
            _scaffoldKey.currentContext, alertTitle, alertContent);
      } else {
        // call loading
        pr = ProgressDialog(_scaffoldKey.currentContext,
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

        // provide verify event
        BlocProvider.of<RequestVerifyOtpBloc>(context)
          ..add(VerifyOTPEvent(cpi: _cpiController.text, otpCode: _otpCode));
        print(_cpiController.text);
        print(_otpCode);
      }
    }
  }

  // click event for next button after verification is successful
  _getPtInfo() {
    // provider for get patient info event
    BlocProvider.of<RequestVerifyOtpBloc>(context)
      ..add(GetPtInfoEvent(cpi: _cpiController.text.toString()));
  }

  // set timer to get OTP again
  void startTimer() {
    CountdownTimer countdownTimer = new CountdownTimer(
        new Duration(seconds: _start), new Duration(seconds: 1));

    var sub = countdownTimer.listen(null);
    sub.onData((duration) {
      if (mounted)
        setState(() {
          _current = _start - duration.elapsed.inSeconds;
        });
    });
    sub.onDone(() {
      sub.cancel();

      // current timing set to 60 s(normal time) and getOTPbtn lable to 'resend otp'
      if (mounted)
        setState(() {
          _current = 60;
          _getOTPBtnLbl = 'Resend OTP';
        });
    });
  }
}
