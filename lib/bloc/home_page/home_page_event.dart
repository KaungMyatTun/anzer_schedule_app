part of 'home_page_bloc.dart';

@immutable
abstract class HomePageEvent {}

class YesEvent extends HomePageEvent{}

class NoEvent extends HomePageEvent{}

class GetPreRequiredData extends HomePageEvent{}
