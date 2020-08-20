import 'package:anzer_schedule_app/util/HexColor.dart';
import 'package:anzer_schedule_app/util/constants.dart';
import 'package:flutter/material.dart';

class TeleMedicinePage extends StatefulWidget {
  @override
  _TeleMedicinePageState createState() => _TeleMedicinePageState();
}

class _TeleMedicinePageState extends State<TeleMedicinePage> {
  AppBar appBar;
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar,
        body: Center(
          child: Text(
            'This feature is coming soon !',
            style: TextStyle(
              color: HexColor(BLACK_COLOR),
            ),
          ),
        ));
  }
}
