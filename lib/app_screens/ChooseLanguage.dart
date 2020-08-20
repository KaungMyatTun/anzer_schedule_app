import 'package:anzer_schedule_app/util/AppLanguage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseLanguage extends StatefulWidget {
  @override
  _ChooseLanguageState createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {
  String _radioValue;
  String langchoice;
  AppLanguage appLanguage = new AppLanguage();

  void checkLanguageCode() async {
    await appLanguage.fetchLocale();
    // print('option 1 ${appLanguage.appLocal}');
    if (appLanguage.appLocal == Locale('en')) {
      setState(() {
        _radioValue = 'english';
      });
    } else {
      setState(() {
        _radioValue = 'myanmar';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkLanguageCode();
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    void radioButtonChanges(String value) {
      setState(() {
        _radioValue = value;
        switch (value) {
          case 'english':
            langchoice = value;
            appLanguage.changeLanguage(Locale('en'));
            // print('changed ${appLanguage.appLocal}');
            break;
          case 'myanmar':
            langchoice = value;
            appLanguage.changeLanguage(Locale('my'));
            // print('changed ${appLanguage.appLocal}');
            break;
        }
        debugPrint(langchoice); //Debug the choice in console
      });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text(
          'choose language',
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(height: 10,),
          Row(
            children: <Widget>[
              Radio(
                value: 'english',
                groupValue: _radioValue,
                onChanged: radioButtonChanges,
              ),
              Text(
                'eng',
              ),
            ],
          ),
          Divider(
            color: Colors.blueGrey,
          ),
          Row(
            children: <Widget>[
              Radio(
                value: 'myanmar',
                groupValue: _radioValue,
                onChanged: radioButtonChanges,
              ),
              Text(
                'myanmar',
              ),
            ],
          ),
          Divider(
            color: Colors.blueGrey,
          ),
        ],
      ),
    );
  }
}
