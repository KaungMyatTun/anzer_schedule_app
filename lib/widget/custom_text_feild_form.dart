import 'package:anzer_schedule_app/util/AppLanguage.dart';
import 'package:anzer_schedule_app/util/HexColor.dart';
import 'package:anzer_schedule_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFieldForm extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String helperText;
  final TextInputType textInputType;
  final Function validator;
  final int maxLines;
  final InputBorder inputBorder;
  final List<TextInputFormatter> inputFormatter;
  final int maxLength;
  final bool readOnly;
  final bool suffixIconVisible;
  final String labelText;
  final FocusNode currentFocus;
  final FocusNode nextFocus;
  @override
  _CustomTextFieldFormState createState() => _CustomTextFieldFormState();

  CustomTextFieldForm(
      {@required this.controller,
      @required this.helperText,
      @required this.hintText,
      this.suffixIconVisible = false,
      this.textInputType,
      this.validator,
      this.maxLines,
      this.inputBorder,
      this.inputFormatter,
      this.maxLength,
      this.readOnly,
      @required this.labelText,
      @required this.currentFocus,
      @required this.nextFocus});
}

class _CustomTextFieldFormState extends State<CustomTextFieldForm> {
  AppLanguage _appLanguage;
  bool engLang = false;

  checkLangCode() async {
    _appLanguage = AppLanguage();
    await _appLanguage.fetchLocale();
    if (_appLanguage.appLocal == Locale('en')) {
      if (mounted) {
        setState(() {
          engLang = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          engLang = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkLangCode();
  }

  @override
  Widget build(BuildContext context) {
    print('eng lang ${engLang.toString()}');
    return TextFormField(
      textInputAction: TextInputAction.done,
      autovalidate: true,
      style: engLang
          ? TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.shortestSide * 0.035,
              letterSpacing: 1.2)
          : TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.shortestSide * 0.035,
              letterSpacing: 0),
      decoration: InputDecoration(
        suffixIcon: widget.suffixIconVisible
            ? Icon(
                Icons.arrow_drop_down,
                color: HexColor(BLACK_COLOR),
              )
            : null,
        border:
            widget.inputBorder != null ? widget.inputBorder : InputBorder.none,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: HexColor(BLACK_COLOR))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: HexColor(BLACK_COLOR))),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: HexColor(BLACK_COLOR))),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: HexColor(BLACK_COLOR))),
        labelText: widget.labelText,
        labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
        counterText: '',
        helperStyle: TextStyle(
            color: HexColor(PRIMARY_COLOR),
            fontSize: MediaQuery.of(context).size.shortestSide * 0.03,
            letterSpacing: 0.8),
        errorStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.shortestSide * 0.03,
            letterSpacing: 0.8),
      ),
      keyboardType: widget.textInputType == null
          ? TextInputType.text
          : widget.textInputType,
      controller: widget.controller,
      maxLines: widget.maxLines != null ? widget.maxLines : 1,
      validator: widget.validator,
      inputFormatters:
          widget.inputFormatter != null ? widget.inputFormatter : [],
      maxLength: widget.maxLength != null ? widget.maxLength : null,
      readOnly: widget.readOnly != null ? widget.readOnly : false,
    );
  }

  // change focus
  _fieldFocusChange(
      BuildContext context, FocusNode currentFoucs, FocusNode nextFocus) {
    currentFoucs.unfocus();
    currentFoucs.nearestScope.nextFocus();
  }
}
