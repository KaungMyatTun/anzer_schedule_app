import 'package:anzer_schedule_app/app_screens/AppAbout.dart';
import 'package:anzer_schedule_app/app_screens/HomePage.dart';
import 'package:anzer_schedule_app/app_screens/SettingPage.dart';

typedef T Constructor<T>();

final Map<String, Constructor<Object>> _constructors =
    <String, Constructor<Object>>{};

void register<T>(Constructor<T> constructor) {
  _constructors[T.toString()] = constructor;
}

class ClassBuilder {
  static void registerClasses() {
    register<HomePage>(() => HomePage());
    register<SettingPage>(() => SettingPage());
    register<AppAbout>(() => AppAbout());
  }

  static dynamic fromString(String type) {
    return _constructors[type]();
  }
}
