import 'package:anzer_schedule_app/app_screens/ChooseLanguage.dart';
import 'package:anzer_schedule_app/util/HexColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';

class SettingPage extends KFDrawerContent {
  SettingPage({
    Key key,
  });

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          leading: ClipRect(
            child: Material(
              shadowColor: Colors.transparent,
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: widget.onMenuPressed,
              ),
            ),
          ),
          title: Text(
            'Setting',
            style: Theme.of(context).textTheme.headline,
          ),
        ),
        backgroundColor: HexColor('#d3d3d3'),
        body: Column(
          children: <Widget>[
            LanguageWidget(),
            _languageSettingLabel(context),
            Container(
              height: 10,
            ),
          ],
        ));
  }
}

class LanguageWidget extends StatefulWidget {
  @override
  _LanguageWidgetState createState() => _LanguageWidgetState();
}

class _LanguageWidgetState extends State<LanguageWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              print('tap on choose language');
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => ChooseLanguage()));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Choose Language',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Spacer(),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
          ),
        ));
  }
}

// -------------- label for language setting ---------------
Widget _languageSettingLabel(BuildContext context) {
  return Container(
    margin: EdgeInsets.only(top: 3),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
          'Choose language setting can be used to change languge of the whole application.'),
    ),
  );
}
