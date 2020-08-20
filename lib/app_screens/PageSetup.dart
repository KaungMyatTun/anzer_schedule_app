import 'package:anzer_schedule_app/app_screens/AppAbout.dart';
import 'package:anzer_schedule_app/app_screens/HomePage.dart';
import 'package:anzer_schedule_app/app_screens/SettingPage.dart';
import 'package:anzer_schedule_app/util/class_builder.dart';
import 'package:anzer_schedule_app/util/localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';

class PageSetup extends StatefulWidget {
  PageSetup({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PageSetupState createState() => _PageSetupState();
}

class _PageSetupState extends State<PageSetup> with TickerProviderStateMixin {
  // declare Drawer Controller
  KFDrawerController _drawerController;

  @override
  void initState() {
    super.initState();
    _drawerController = KFDrawerController(
        initialPage: ClassBuilder.fromString('HomePage'),
        items: [
          KFDrawerItem.initWithPage(
            text: Text(
              'Home',
              style: TextStyle(fontSize: 16),
            ),
            icon: Icon(Icons.home),
            page: HomePage(),
          ),
          KFDrawerItem.initWithPage(
            text: Text('Setting', style: TextStyle(fontSize: 16)),
            icon: Icon(Icons.settings),
            page: SettingPage(),
          ),
          KFDrawerItem.initWithPage(
            text: Text('About', style: TextStyle(fontSize: 16)),
            icon: Icon(Icons.info),
            page: AppAbout(),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KFDrawer(
        controller: _drawerController,
        header: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Container()),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context).apptitle,
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
            )
          ],
        ),
        footer: Container(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(50, 255, 255, 1.0),
              Color.fromRGBO(74, 72, 250, 50.0)
            ],
            tileMode: TileMode.repeated,
          ),
        ),
      ),
    );
  }
}
