import 'package:anzer_schedule_app/app_screens/PageSetup.dart';
import 'package:anzer_schedule_app/bloc/introduction_page/introduction_page_bloc.dart';
import 'package:anzer_schedule_app/bloc/main_bloc/schedule_main_bloc.dart';
import 'package:anzer_schedule_app/widget/onboarding_header_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  // declare app bar
  AppBar appBar;
  // to show loading
  bool _loading = false;
  // error message
  String _errorMessage = "";
  ScheduleMainBloc _bloc;

  @override
  initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((_) {
      BlocProvider.of<IntroductionPageBloc>(context)..add(GetPreRequiredData());
    });
    // initiate the schedule main bloc
    _bloc = ScheduleMainBloc();
  }

  @override
  Widget build(BuildContext context) {
    appBar = AppBar();
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: BlocListener<IntroductionPageBloc, IntroductionPageState>(
          listener: (context, state) {
            if (state is LoadingIntroductionState) {
              if (mounted) {
                setState(() {
                  _loading = true;
                });
              }
            }
            if (state is LoadedIntroductionState) {
              print(state.doctor[0].docName);

              Future.delayed(Duration(seconds: 2)).then((_) {
                // set loading invisible
                if (mounted) {
                  setState(() {
                    _loading = false;
                  });
                }
                // set result to doctor service and doctor list
                _bloc.doctorServices.addAll(state.docService);
                _bloc.doctor.addAll(state.doctor);

                print(_bloc.doctor.length.toString());

                // navigate to home page
                Navigator.of(context).pushReplacement(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return PageSetup();
                }));
              });
            }
            if (state is ErrorIntroductionState) {
              _errorMessage = state.error.toString();
            }
          },
          child: BlocBuilder<IntroductionPageBloc, IntroductionPageState>(
            builder: (context, state) {
              return _buildMainBody();
            },
          ),
        ));
  }

  // build main body
  Widget _buildMainBody() {
    return Stack(fit: StackFit.expand, children: <Widget>[
      Center(
        child: _buildBodyWidget(),
      ),
      Positioned(
        bottom: 50,
        width: MediaQuery.of(context).size.width,
        child: _loadingAndErrorWidget(),
      ),
    ]);
  }

  // build body widget of introduction screen
  Widget _buildBodyWidget() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: appBar.preferredSize.height.toDouble()),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 100,
                  width: 100,
                  child: Image.asset("assets/sms_send.png")),
              Align(
                  alignment: Alignment.center,
                  child: OnBoardingHeaderText(
                    text: 'Anzer Scheduling',
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // build loading and error widget
  Widget _loadingAndErrorWidget() {
    return Column(
      children: <Widget>[
        _loading ? CupertinoActivityIndicator() : Container(),
        SizedBox(
          height: 20,
        ),
        Text(
          _errorMessage,
          style: TextStyle(color: Colors.red),
        )
      ],
    );
  }
}
