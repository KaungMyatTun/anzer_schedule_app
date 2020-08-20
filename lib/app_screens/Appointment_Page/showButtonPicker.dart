import 'package:anzer_schedule_app/util/HexColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showButtonPicker(BuildContext context, List<String> _list,
    TextEditingController _controller) {
  String _selectedValue = _list[0];
  return showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (BuildContext context) {
        return Container(
          height: 210,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 15, right: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 15, right: 20),
                    child: InkWell(
                      onTap: () {
                        _controller.text = _selectedValue;
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Done",
                        style:
                            TextStyle(fontSize: 16, color: HexColor('#3057B8')),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(),
                    looping: false,
                    backgroundColor: Colors.grey[50],
                    itemExtent: 40.0,
                    onSelectedItemChanged: (int index) {
                      _selectedValue = _list[index];
                    },
                    children:
                        new List<Widget>.generate(_list.length, (int index) {
                      return new Center(
                        child: new Text(_list[index],
                            style: TextStyle(fontSize: 16)),
                      );
                    })),
              ),
            ],
          ),
        );
      });
}
