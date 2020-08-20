import 'package:anzer_schedule_app/util/HexColor.dart';
import 'package:anzer_schedule_app/util/constants.dart';
import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  final int dotsCount;
  final int position;

  DotsIndicator({
    Key key,
    @required this.dotsCount,
    this.position = 0,
  })  : assert(dotsCount != null && dotsCount > 0),
        assert(position != null && position >= 0),
        assert(
            position < dotsCount, "Position must be inferior than dotsCount"),
        super(key: key);

  Widget _buildDot(int index) {
    final isCurrent = index == position;
    final size = isCurrent ? Size.square(30.0) : Size.square(20.0);

    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              margin: isCurrent
                  ? EdgeInsets.only(right: 3, left: 3)
                  : EdgeInsets.only(right: 0, left: 0),
              child: isCurrent
                  ? Text(
                      'Step',
                      style: TextStyle(color: HexColor(WHITE_COLOR)),
                    )
                  : Container(),
            ),
            Container(
              width: size.width,
              height: size.height,
              margin: EdgeInsets.all(3.0),
              decoration: ShapeDecoration(
                  color: isCurrent ? Colors.white : Colors.white60,
                  shape: isCurrent ? CircleBorder() : CircleBorder()),
              child: Center(child: Text('${index + 1}', style: TextStyle(color: Colors.black),)),
            ),
            index != 2 ? line() : Container(),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dotsList = List<Widget>.generate(dotsCount, _buildDot);

    return Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: HexColor(PRIMARY_COLOR)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: dotsList));
  }

  // horizontal line
  Widget line() {
    return Container(
      color: Colors.white60,
      height: 2.0,
      width: 60.0,
    );
  }
}
