import 'package:flutter/material.dart';

class AvailableTimeNotification extends Notification{
  Map<DateTime, List> events;
  AvailableTimeNotification({this.events});
}