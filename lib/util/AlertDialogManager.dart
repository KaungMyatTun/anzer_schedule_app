import 'package:anzer_schedule_app/util/HexColor.dart';
import 'package:anzer_schedule_app/widget/rounded_button.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'constants.dart';

class AlertDialogManager {
  // awesome alert dialog
  static awesomeAlertDialog(
      BuildContext context, String alertTitle, String tt) {
    // AwesomeDialog(
    //   context: context,
    //   keyboardAware: true,
    //   dismissOnBackKeyPress: false,
    //   dialogType: DialogType.INFO,
    //   animType: AnimType.BOTTOMSLIDE,
    //   btnOkText: "OK",
    //   title: 'OTP Password',
    //   padding: const EdgeInsets.all(16.0),
    //   desc: tt,
    //   btnOkOnPress: () {},
    //   btnOkColor: HexColor(PRIMARY_COLOR)
    // ).show();

    AwesomeDialog(
            context: context,
            keyboardAware: true,
            dismissOnBackKeyPress: false,
            dialogType: DialogType.INFO,
            animType: AnimType.BOTTOMSLIDE,
            padding: const EdgeInsets.all(16.0),
            body: Column(
              children: [
                Center(
                    child: Text(
                  alertTitle,
                  textScaleFactor: 1.5,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                Text(tt),
                SizedBox(
                  height: 20,
                ),
                RoundedButton(
                  text: 'OK',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  colorString: PRIMARY_COLOR,
                ),
              ],
            ),
            btnOkColor: HexColor(PRIMARY_COLOR))
        .show();
  }

  // awesome error dialog
  static awesomeErrorDialog(
      BuildContext context, String alertTitle, String tt) {
    // AwesomeDialog(
    //   context: context,
    //   keyboardAware: true,
    //   dismissOnBackKeyPress: false,
    //   dialogType: DialogType.ERROR,
    //   animType: AnimType.BOTTOMSLIDE,
    //   btnOkText: "OK",
    //   title: 'OTP Password',
    //   padding: const EdgeInsets.all(16.0),
    //   desc: tt,
    //   btnOkOnPress: () {},
    //   btnOkColor: HexColor(PRIMARY_COLOR)
    // ).show();
    AwesomeDialog(
            context: context,
            keyboardAware: true,
            dismissOnBackKeyPress: false,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            padding: const EdgeInsets.all(16.0),
            body: Column(
              children: [
                Center(
                    child: Text(
                  alertTitle,
                  textScaleFactor: 1.5,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                Text(tt),
                SizedBox(
                  height: 20,
                ),
                RoundedButton(
                  text: 'OK',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  colorString: PRIMARY_COLOR,
                ),
              ],
            ),
            btnOkColor: HexColor(PRIMARY_COLOR))
        .show();
  }

  // for getting otp code alert message
  static alertGetOTPDialog(
      BuildContext context, String alertTitle, EasyRichText tt) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(alertTitle),
            content: tt,
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Yes"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],

            // child: SimpleDialog(
            //   title: Text(alertTitle),
            //   children: <Widget>[
            //     new SimpleDialogOption(
            //       child: Text('Yes'),
            //       onPressed: (){
            //         Navigator.pop(context);
            //       },
            //     )
            //   ],
            // ),
          );
        });
  }

  // for normal alert dialog
  // static alertDialog(
  //     BuildContext context, String alertTitle, String alertContent) {
  //   SchedulerBinding.instance.addPostFrameCallback((_) {
  //     showDialog(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (BuildContext context) {
  //           return CupertinoAlertDialog(
  //             title: Text(alertTitle),
  //             content: Text(alertContent),
  //             actions: <Widget>[
  //               CupertinoDialogAction(
  //                 isDefaultAction: true,
  //                 child: Text("Yes"),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //               )
  //             ],
  //           );
  //         });
  //   });
  // }
}
