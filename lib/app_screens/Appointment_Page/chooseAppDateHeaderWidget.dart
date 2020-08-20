import 'package:anzer_schedule_app/util/HexColor.dart';
import 'package:anzer_schedule_app/util/constants.dart';
import 'package:flutter/material.dart';

class ChooseAppDateHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return // choose appointment date header
        Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: HexColor(PRIMARY_COLOR)),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).primaryColor,
                  size: MediaQuery.of(context).size.height * 0.03,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Choose Appointment Date',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      // fontWeight: FontWeight.bold,
                      fontSize: 18),
                )
              ])),
    );
  }
}
