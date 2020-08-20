import 'package:anzer_schedule_app/bloc/main_bloc/schedule_main_bloc.dart';
import 'package:flutter/material.dart';

class ScheduleMainBlocProvider extends InheritedWidget{
  final ScheduleMainBloc bloc;

  const ScheduleMainBlocProvider({
    Key key,
    @required this.bloc,
    Widget child,
  }) : super(key: key, child : child);

  @override
  bool updateShouldNotify(_) => true;

  static ScheduleMainBloc of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(ScheduleMainBlocProvider) as ScheduleMainBlocProvider).bloc;
  }
}