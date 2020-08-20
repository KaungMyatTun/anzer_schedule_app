import 'package:anzer_schedule_app/app_screens/Appointment_Page/showButtonPicker.dart';
import 'package:anzer_schedule_app/bloc/appointment_page/appointment_page_bloc.dart';
import 'package:anzer_schedule_app/bloc/main_bloc/schedule_main_bloc.dart';
import 'package:anzer_schedule_app/network/model/pt_info.dart';
import 'package:anzer_schedule_app/util/AgeCalculation.dart';
import 'package:anzer_schedule_app/util/HexColor.dart';
import 'package:anzer_schedule_app/util/ProgressDialog.dart';
import 'package:anzer_schedule_app/util/constants.dart';
import 'package:anzer_schedule_app/widget/custom_text_feild_form.dart';
import 'package:anzer_schedule_app/widget/onboarding_header_text.dart';
import 'package:anzer_schedule_app/widget/rounded_button.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class RequestPatientInfo extends StatefulWidget {
  final ScheduleMainBloc bloc;
  RequestPatientInfo({@required this.bloc});
  @override
  _RequestPatientInfoState createState() => _RequestPatientInfoState();
}

class _RequestPatientInfoState extends State<RequestPatientInfo> {
  // progress dialog
  ProgressDialog pr;

  // declare required textformfield
  TextEditingController _surnameController;
  TextEditingController _givennameController;
  TextEditingController _dobController;
  TextEditingController _ageController;
  TextEditingController _genderController;
  TextEditingController _codeController;
  TextEditingController _phoneController;
  TextEditingController _addressController;

  // focus node
  FocusNode _surnameFocus;
  FocusNode _givenNameFocus;
  FocusNode _phoneNameFocus;
  FocusNode _addressNameFocus;

  // gender item list
  List<String> gender = ["Male", "Female", "Other"];
  // global form key for textformfield validation
  final _formKey = GlobalKey<FormState>();
  // to check is first time data loaded
  bool isFirstTime;
  // declare dateformat
  final df = new DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    _surnameController = TextEditingController();
    _givennameController = TextEditingController();
    _dobController = TextEditingController();
    _ageController = TextEditingController();
    _genderController = TextEditingController();
    _codeController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();

    // focus node
    _surnameFocus = FocusNode();
    _givenNameFocus = FocusNode();
    _phoneNameFocus = FocusNode();
    _addressNameFocus = FocusNode();

    if (widget.bloc.patientInfo.isNotEmpty) {
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
      // provide set pateint info to associate texformfield controllers
      BlocProvider.of<AppointmentPageBloc>(context)..add(SetPatientInfoEvent());

      // enable next page button if patient info is not null.
      widget.bloc.enableNextPageButton(true);
    } else {
      widget.bloc.enableSavePatientInfoButton(false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.bloc.patientInfo != null &&
        widget.bloc.patientInfo.length != 0) {
      // set values to controllers
      _setValueToControllers();
    }
    _givennameController..addListener(_onGivenNameChange);
    _surnameController..addListener(_onSurnameChange);
    _dobController..addListener(_onDobChange);
    _ageController..addListener(_onAgeChange);
    _genderController..addListener(_onGenderChange);
    // _codeController..addListener(_onCodeChange);
    _phoneController..addListener(_onPhoneChange);
    _addressController..addListener(_onAddressChange);
  }

  // given name on text change listener
  void _onGivenNameChange() {
    if (widget.bloc.patientInfo.length != 0) {
      if (widget.bloc.patientInfo != null &&
          widget.bloc.patientInfo[0] != null &&
          _givennameController.text != widget.bloc.patientInfo[0].ptGivenName) {
        _enableSaveButton();
        widget.bloc.nextButtonEnableSink.add(false);
      }
      if (_givennameController.text.length == 0) {
        widget.bloc.enableSavePatientInfoButton(false);
      }
    } else {
      _enableSaveButton();
      widget.bloc.nextButtonEnableSink.add(false);
    }
  }

  // surname on text change listener
  void _onSurnameChange() {
    if (widget.bloc.patientInfo.length != 0) {
      if (widget.bloc.patientInfo != null &&
          widget.bloc.patientInfo[0] != null &&
          _surnameController.text != widget.bloc.patientInfo[0].ptSurname) {
        // widget.bloc.enableSavePatientInfoButton(true);
        _enableSaveButton();
        widget.bloc.nextButtonEnableSink.add(false);
      }
      if (_surnameController.text.length == 0) {
        widget.bloc.enableSavePatientInfoButton(false);
      }
    } else {
      _enableSaveButton();
      widget.bloc.nextButtonEnableSink.add(false);
    }
  }

  // date of birth on text change listener
  void _onDobChange() {
    if (widget.bloc.patientInfo.length != 0) {
      if (widget.bloc.patientInfo != null &&
          widget.bloc.patientInfo[0] != null &&
          _dobController.text != widget.bloc.patientInfo[0].ptDob) {
        // widget.bloc.enableSavePatientInfoButton(true);
        _enableSaveButton();
        widget.bloc.nextButtonEnableSink.add(false);
      }
      if (_dobController.text.length == 0) {
        widget.bloc.enableSavePatientInfoButton(false);
      }
    } else {
      _enableSaveButton();
      widget.bloc.nextButtonEnableSink.add(false);
    }
  }

  // age on text change listener
  void _onAgeChange() {
     // clear dob if age textformfield is null
      _dobController.text = "";
      widget.bloc.enableSavePatientInfoButton(false);
    if (_ageController.text.length == 0) {
      // clear dob if age textformfield is null
      _dobController.text = "";
      widget.bloc.enableSavePatientInfoButton(false);
    } else {
      // if the dob field is already exist, no need to calculate the dob
      _dobController.text.isEmpty
          ? _dobController.text =
              AgeCalculation().calculateDoB(int.parse(_ageController.text))
          : null;
    }
    if (widget.bloc.patientInfo.length != 0) {
      if (widget.bloc.patientInfo != null &&
          widget.bloc.patientInfo[0] != null &&
          _ageController.text != widget.bloc.patientInfo[0].ptAge.toString()) {
        // widget.bloc.enableSavePatientInfoButton(true);
        _enableSaveButton();
        widget.bloc.nextButtonEnableSink.add(false);
      }
      if (_ageController.text.length == 0) {
        // clear dob if age textformfield is null
        _dobController.text = "";
        widget.bloc.enableSavePatientInfoButton(false);
      }
    } else {
      _enableSaveButton();
      widget.bloc.nextButtonEnableSink.add(false);
    }
  }

  // gender on text change listener
  void _onGenderChange() {
    if (widget.bloc.patientInfo.length != 0) {
      if (widget.bloc.patientInfo != null &&
          widget.bloc.patientInfo[0] != null &&
          _genderController.text != widget.bloc.patientInfo[0].ptSex) {
        // widget.bloc.enableSavePatientInfoButton(true);
        _enableSaveButton();
        widget.bloc.nextButtonEnableSink.add(false);
      }
      if (_genderController.text.length == 0) {
        widget.bloc.enableSavePatientInfoButton(false);
      }
    } else {
      _enableSaveButton();
      widget.bloc.nextButtonEnableSink.add(false);
    }
  }

  // phone on text change listener
  void _onPhoneChange() {
    if (widget.bloc.patientInfo.length != 0) {
      if (widget.bloc.patientInfo != null &&
          widget.bloc.patientInfo[0] != null &&
          _phoneController.text != widget.bloc.patientInfo[0].ptMobilePhone) {
        // widget.bloc.enableSavePatientInfoButton(true);
        _enableSaveButton();
        widget.bloc.nextButtonEnableSink.add(false);
      }
      if (_phoneController.text.length == 0) {
        widget.bloc.enableSavePatientInfoButton(false);
      }
    } else {
      _enableSaveButton();
      widget.bloc.nextButtonEnableSink.add(false);
    }
  }

  // address on text change listener
  void _onAddressChange() {
    if (widget.bloc.patientInfo.length != 0) {
      if (widget.bloc.patientInfo != null &&
          widget.bloc.patientInfo[0] != null &&
          _addressController.text != widget.bloc.patientInfo[0].ptAddress) {
        // widget.bloc.enableSavePatientInfoButton(true);
        _enableSaveButton();
        widget.bloc.nextButtonEnableSink.add(false);
      }
      if (_addressController.text.length == 0) {
        widget.bloc.enableSavePatientInfoButton(false);
      }
    } else {
      _enableSaveButton();
      widget.bloc.nextButtonEnableSink.add(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    // widget.bloc.dispose();
    _surnameController.dispose();
    _givennameController.dispose();
    _dobController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _codeController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentPageBloc, AppointmentPageState>(
        listener: (context, state) async {
      if (state is AppointmentPageInitial) {}
      if (state is LoadingSetPatientInfoState) {
        // pr.show();
        // isFirstTime ? pr.show() : Container();
      }
      if (state is LoadedSetPatientInfoState) {
        // await Future.delayed(Duration(seconds: 1)).then((value) {
        // pr.hide();
        // // set values to controllers
        // _setValueToControllers();

        // // to enable next button
        // _enableNextButton();
        // });
      }
    }, child: BlocBuilder<AppointmentPageBloc, AppointmentPageState>(
            builder: (context, state) {
      return _buildAppointmentPage();
    }));
  }

  // build appointment page widget
  Widget _buildAppointmentPage() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: <Widget>[
              // appointment for title
              Row(
                children: <Widget>[
                  // Icon(
                  //   Icons.person,
                  //   color: Theme.of(context).accentColor,
                  //   size: MediaQuery.of(context).size.height * 0.04,
                  // ),
                  OnBoardingHeaderText(
                    text: 'Appointment for',
                  )
                ],
              ),
              // patient given name
              SizedBox(
                height: 20,
              ),
              CustomTextFieldForm(
                labelText: 'Given Name',
                hintText: 'Given Name',
                helperText: "",
                controller: _givennameController,
                currentFocus: _givenNameFocus,
                nextFocus: _surnameFocus,
                validator: (val) => val.length == 0
                    ? 'Enter your given name (e.g Mg, Ma)'
                    : null,
              ),
              // patient surname
              SizedBox(
                height: 10,
              ),
              CustomTextFieldForm(
                  labelText: 'Surname',
                  hintText: 'Surname',
                  helperText: '',
                  controller: _surnameController,
                  currentFocus: _surnameFocus,
                  nextFocus: null,
                  validator: (val) =>
                      val.length == 0 ? 'Enter your fullname' : null),
              // patient dob and age
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: CustomTextFieldForm(
                        labelText: 'DoB',
                        hintText: 'DoB',
                        readOnly: true,
                        helperText: '',
                        currentFocus: null,
                        nextFocus: null,
                        controller: _dobController,
                        validator: (val) =>
                            val.length == 0 ? 'Enter your DoB' : null),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: InkWell(
                      onTap: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true, onChanged: (date) {
                          print("${date.year}-${date.month}-${date.day}");
                          // _dobController.text =
                          //     "${date.day}/${date.month}/${date.month}";
                          // _dobController.text = date.toString();
                          _dobController.text = df.format(date);
                        }, onConfirm: (date) {
                          // print("${date.year}-${date.month}-${date.day}");
                          // _dobController.text =
                          //     "${date.day}/${date.month}/${date.month}";
                          // print(AgeCalculation().calculateAge(date));
                          // _dobController.text = date.toString();
                          _dobController.text = df.format(date);
                          _ageController.text =
                              AgeCalculation().calculateAge(date).toString();
                        });
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Icon(
                        Icons.calendar_today,
                        color: HexColor(BLACK_COLOR),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Flexible(
                    child: Container(
                      child: CustomTextFieldForm(
                          labelText: 'Age',
                          hintText: 'Age',
                          helperText: '',
                          controller: _ageController,
                          currentFocus: null,
                          nextFocus: null,
                          textInputType: TextInputType.number,
                          validator: (val) => val.length == 0 ? 'Age?' : null),
                    ),
                  ),
                ],
              ),
              // gender
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  showButtonPicker(context, gender, _genderController);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: IgnorePointer(
                  child: CustomTextFieldForm(
                      labelText: 'Gender',
                      readOnly: true,
                      hintText: 'Gender',
                      helperText: '',
                      suffixIconVisible: true,
                      controller: _genderController,
                      currentFocus: null,
                      nextFocus: null,
                      validator: (val) =>
                          val.length == 0 ? 'Choose your gender' : null),
                ),
              ),

              // country code and phone number
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        border: Border.all(color: HexColor(BLACK_COLOR)),
                        borderRadius: BorderRadius.circular(10)),
                    child: CountryCodePicker(
                      showFlag: true,
                      initialSelection: 'MM',
                      onInit: (code) => print(code.dialCode),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: CustomTextFieldForm(
                        labelText: 'Phone number',
                        controller: _phoneController,
                        hintText: "Phone number",
                        helperText: '',
                        textInputType: TextInputType.phone,
                        currentFocus: _phoneNameFocus,
                        nextFocus: _addressNameFocus,
                        validator: (val) =>
                            val.length == 0 ? 'Enter your phone number' : null),
                  )
                ],
              ),
              // gender
              SizedBox(
                height: 10,
              ),
              CustomTextFieldForm(
                  labelText: 'Address',
                  hintText: 'Address',
                  helperText: '',
                  controller: _addressController,
                  currentFocus: _addressNameFocus,
                  nextFocus: null,
                  validator: (val) =>
                      val.length == 0 ? 'Enter your address' : null),
              SizedBox(
                height: 24,
              ),
              StreamBuilder<bool>(
                  stream: widget.bloc.savePatientInfoButtonEnableStream,
                  builder: (context, snapshot) {
                    bool isEnable = snapshot.hasData
                        ? snapshot.data
                        : widget.bloc.patientInfo != null ? false : true;
                    return RoundedButton(
                      text: 'Save',
                      colorString: PRIMARY_COLOR,
                      onPressed: isEnable ? _savePatientInfo : null,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  // save PatientInfo()
  void _savePatientInfo() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      widget.bloc.enableSavePatientInfoButton(false);

      PtInfo tempPtInfo = PtInfo(
        ptCpi: "1988",
        ptGivenName: _givennameController.text,
        ptSurname: _surnameController.text,
        ptDob: _dobController.text,
        ptDod: null,
        ptAge: int.parse(_ageController.text),
        ptSex: _genderController.text,
        ptMobilePhone: _phoneController.text,
        ptAddress: _addressController.text,
      );

      // clear patient info list before insert new data
      widget.bloc.patientInfo.clear();
      // insert new data to patient info list
      widget.bloc.patientInfo.add(tempPtInfo);
      print(widget.bloc.patientInfo.length.toString());
      if (widget.bloc.patientInfo.length > 0) {
        widget.bloc.nextButtonEnableSink.add(true);
        widget.bloc.patientInfoListModifiedSink.add(tempPtInfo);
      } else {
        widget.bloc.nextButtonEnableSink.add(false);
      }
    }
  }

  // enable next button
  void _enableSaveButton() {
    if (_givennameController.text.length > 0 &&
        _surnameController.text.length > 0 &&
        _phoneController.text.length > 0 &&
        _addressController.text.length > 0 &&
        _genderController.text.length > 0 &&
        _ageController.text.length > 0) {
      widget.bloc.enableSavePatientInfoButton(true);
      widget.bloc.nextButtonEnableSink.add(false);
    } else {
      widget.bloc.enableSavePatientInfoButton(false);
      widget.bloc.nextButtonEnableSink.add(false);
    }
  }

  // set value to controller
  void _setValueToControllers() {
    _givennameController.text = widget.bloc.patientInfo[0] != null
        ? widget.bloc.patientInfo[0].ptGivenName
        : '';
    _surnameController.text = widget.bloc.patientInfo[0] != null
        ? widget.bloc.patientInfo[0].ptSurname
        : '';
    _dobController.text = widget.bloc.patientInfo[0] != null
        ? widget.bloc.patientInfo[0].ptDob
        : '';
    _ageController.text = widget.bloc.patientInfo[0] != null
        ? widget.bloc.patientInfo[0].ptAge.toString()
        : '';

    if (widget.bloc.patientInfo[0] != null) {
      if (widget.bloc.patientInfo[0].ptSex.toLowerCase().toString() == "male" ||
          widget.bloc.patientInfo[0].ptSex.toLowerCase().toString() == 'm') {
        _genderController.text = gender[0].toString();
      } else if (widget.bloc.patientInfo[0].ptSex.toLowerCase().toString() ==
              "female" ||
          widget.bloc.patientInfo[0].ptSex.toLowerCase().toString() == 'f') {
        _genderController.text = gender[1].toString();
      } else {
        print('done this');
        _genderController.text = gender[2].toString();
      }
    } else {
      _genderController.text = '';
    }

    _phoneController.text = widget.bloc.patientInfo[0] != null
        ? widget.bloc.patientInfo[0].ptMobilePhone
        : '';
    _addressController.text = widget.bloc.patientInfo[0] != null
        ? widget.bloc.patientInfo[0].ptAddress
        : '';
  }
}
