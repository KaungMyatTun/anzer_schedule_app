import 'package:anzer_schedule_app/bloc/main_bloc/schedule_main_bloc.dart';
import 'package:anzer_schedule_app/util/HexColor.dart';
import 'package:anzer_schedule_app/util/constants.dart';
import 'package:flutter/material.dart';

class PreviousPageButton extends StatelessWidget {
  final ScheduleMainBloc bloc;
  PreviousPageButton({@required this.bloc});
  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 24,
        right: 64,
        child: StreamBuilder<double>(
            stream: bloc.mainPagerStream,
            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
              double pageOffset = snapshot.hasData ? snapshot.data : 0.0;
              return Transform.translate(
                  offset: Offset(
                      -_getXOffset(
                          pageOffset, MediaQuery.of(context).size.width),
                      0),
                  child: ClipOval(
                      child: Container(
                    height: 32,
                    width: 32,
                    color: HexColor(PRIMARY_COLOR),
                    child: IconButton(
                      padding: EdgeInsets.all(4),
                      color: Colors.white,
                      onPressed: () {
                        bloc.navigateToPreviousPageIfPossible();
                      },
                      icon: Icon(Icons.keyboard_arrow_left),
                    ),
                  )));
            }));
  }
}

double _getXOffset(double pageOffset, double width) {
  double xOffset = -width * 0.1;
  if (pageOffset >= 0 && pageOffset <= 1) {
    xOffset = width * 0.4 * (pageOffset - 1);
  } else if (pageOffset == 2) {
    xOffset = -48;
  } else {
    xOffset = 0;
  }
  return xOffset;
}
