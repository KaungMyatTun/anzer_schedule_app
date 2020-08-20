import 'package:anzer_schedule_app/app_screens/Introduction_Page/introduction_screen.dart';
import 'package:anzer_schedule_app/app_screens/PageSetup.dart';
import 'package:anzer_schedule_app/bloc/allDone_page/alldone_page_bloc.dart';
import 'package:anzer_schedule_app/bloc/appointment_page/appointment_page_bloc.dart';
import 'package:anzer_schedule_app/bloc/home_page/home_page_bloc.dart';
import 'package:anzer_schedule_app/bloc/introduction_page/introduction_page_bloc.dart';
import 'package:anzer_schedule_app/bloc/request_appointment_data/request_appointment_data_bloc.dart';
import 'package:anzer_schedule_app/bloc/request_verify_otp/request_verify_otp_bloc.dart';
import 'package:anzer_schedule_app/network/api_service.dart';
import 'package:anzer_schedule_app/util/AppLanguage.dart';
import 'package:anzer_schedule_app/util/HexColor.dart';
import 'package:anzer_schedule_app/util/class_builder.dart';
import 'package:anzer_schedule_app/util/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  ClassBuilder.registerClasses();
  runApp(MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatefulWidget {
  final AppLanguage appLanguage;
  MyApp({this.appLanguage});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // api service provider
        Provider<ApiService>(
          create: (context) => ApiService.create(),
        ),
        // language provider
        ChangeNotifierProvider<AppLanguage>(
          create: (context) => widget.appLanguage,
        )
      ],
      child: Consumer2<ApiService, AppLanguage>(
        builder: (context, apiService, model, child) {
          return MultiBlocProvider(
            providers: [
              // greeting page bloc
              BlocProvider<HomePageBloc>(
                create: (context) => HomePageBloc(api: apiService),
              ),
              // request and verify OTP bloc
              BlocProvider<RequestVerifyOtpBloc>(
                create: (context) => RequestVerifyOtpBloc(api: apiService),
              ),
              // appointment page bloc
              BlocProvider<AppointmentPageBloc>(
                create: (context) => AppointmentPageBloc(),
              ),
              // request appointment detail info bloc
              BlocProvider<RequestAppointmentDataBloc>(
                create: (context) =>
                    RequestAppointmentDataBloc(api: apiService),
              ),
              // fetch pre required data
              BlocProvider<IntroductionPageBloc>(
                create: (context) => IntroductionPageBloc(api: apiService),
              ),
              // submit app data to server
              BlocProvider<AlldonePageBloc>(
                create: (context) => AlldonePageBloc(api: apiService),
              )
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: Colors.white,
                accentColor: HexColor('#3057B8'),
                primarySwatch: Colors.deepOrange,
                textTheme: TextTheme(),
                bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.yellow)
              ),
              localizationsDelegates: [
                const AppLocalizationDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              locale: model.appLocal,
              supportedLocales: [
                const Locale('en', 'US'),
                const Locale('my', '')
              ],
              home: PageSetup(),
              // home: IntroductionScreen(),
            ),
          );
        },
      ),
    );
  }
}
