import 'package:anzer_schedule_app/util/AppLanguage.dart';
import 'package:anzer_schedule_app/util/HexColor.dart';
import 'package:flutter/material.dart';

class OnBoardingHeaderText extends StatefulWidget {
  final String text;
  final String color;

  const OnBoardingHeaderText({@required this.text, this.color = "#000000"});

  @override
  _OnBoardingHeaderTextState createState() => _OnBoardingHeaderTextState();
}

class _OnBoardingHeaderTextState extends State<OnBoardingHeaderText> {
  AppLanguage _appLanguage;
  bool engLang = false;

  checkLangCode() async {
    _appLanguage = AppLanguage();
    await _appLanguage.fetchLocale();
    if (_appLanguage.appLocal == Locale('en')) {
      setState(() {
        engLang = true;
      });
    } else {
      setState(() {
        engLang = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: Text(
        widget.text,
        style: engLang
            ? TextStyle(
                color: HexColor(widget.color),
                fontSize: MediaQuery.of(context).size.shortestSide * 0.07,
                letterSpacing: 0.8)
            : TextStyle(
                color: HexColor(widget.color),
                fontSize: MediaQuery.of(context).size.shortestSide * 0.05,
                letterSpacing: 0.0),
        softWrap: true,
        textAlign: TextAlign.left,
      ),
    );
  }
}
