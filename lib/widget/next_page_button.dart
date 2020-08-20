import 'package:anzer_schedule_app/bloc/main_bloc/schedule_main_bloc.dart';
import 'package:anzer_schedule_app/util/HexColor.dart';
import 'package:anzer_schedule_app/util/constants.dart';
import 'package:flutter/material.dart';

class NextPageButton extends StatelessWidget {
  final ScheduleMainBloc bloc;
  NextPageButton({@required this.bloc});

  @override
  Widget build(BuildContext context) {
    final _bloc = bloc;
    return Positioned(
      bottom: 24,
      right: 24,
      child: StreamBuilder<double>(
        stream: _bloc.mainPagerStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          double pageOffset = snapshot.hasData ? snapshot.data : 0.0;
          return Transform.translate(
            offset: Offset(
                _getXOffset(pageOffset, MediaQuery.of(context).size.width), 0),
            child: ClipOval(
              child: StreamBuilder<bool>(
                stream: _bloc.nextButtonEnableStream,
                builder: (context, snapshotEanble) {
                  var isEnable =
                      snapshotEanble.hasData ? snapshotEanble.data : false;
                  print("next button enable > $isEnable");
                  return Container(
                    height: 32,
                    width: 32,
                    color: isEnable ? HexColor(PRIMARY_COLOR) : Colors.grey,
                    child: IconButton(
                      padding: EdgeInsets.all(4),
                      color: Colors.white,
                      onPressed: isEnable
                          ? () => _bloc.navigateToNextPageIfPossible()
                          : null,
                      icon: Icon(Icons.keyboard_arrow_right),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  double _getXOffset(double pageOffset, double width) {
    double xOffset = 0;
    if (pageOffset > 1 && pageOffset <= 2) {
      xOffset = width * 0.4 * (pageOffset - 8);
    } else {
      xOffset = 0;
    }
    return xOffset;
  }
}
