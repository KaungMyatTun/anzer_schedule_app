import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';

class AppAbout extends KFDrawerContent {
  AppAbout({
    Key key,
  });

  @override
  _AppAboutState createState() => _AppAboutState();
}

class _AppAboutState extends State<AppAbout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
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
          'About App',
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: SafeArea(
          bottom: false,
          child: Center(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: Center(
                      child: Text('App About'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
