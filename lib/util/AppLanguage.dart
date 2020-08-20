import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage extends ChangeNotifier {
  Locale _appLocale = Locale('en');
  Locale get appLocal => _appLocale ?? Locale('en');
  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      _appLocale = Locale('en');
      return Null;
    }
    _appLocale = Locale(prefs.getString('language_code'));
    return Null;
  }

  // String _appDefScreen = 'doctor';
  // String get appDefScreen => _appDefScreen ?? 'doctor';
  // fetchDefScreen() async{
  //   var prefs = await SharedPreferences.getInstance();
  //   if(prefs.getString('default_screen') == null){
  //     _appDefScreen = 'doctor';
  //   }
  //   _appDefScreen = prefs.getString('default_screen');
  //   return Null;
  // }

  // ---------------------- set change language setting -------------------------
  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    if (_appLocale == type) {
      return;
    }
    if (type == Locale('my')) {
      _appLocale = Locale('my');
      await prefs.setString('language_code', 'my');
      await prefs.setString('countryCode', '');
    } else {
      _appLocale = Locale('en');
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', 'US');
    }
    notifyListeners();
  }

  // // --------------------- set change default screen setting -------------------------
  // void setDfScreen(String screenType) async{
  //   var prefs = await SharedPreferences.getInstance();
  //   if(screenType == 'doctor'){
  //     await prefs.setString('default_screen', 'doctor');
  //   }else{
  //     await prefs.setString('default_screen', 'patient');
  //   }
  //   notifyListeners();
  // }
}
