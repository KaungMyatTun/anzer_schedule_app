import 'package:anzer_schedule_app/util/availableTimeNotification.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarAndEvent extends StatefulWidget {
  
  @override
  _CalendarAndEventState createState() => _CalendarAndEventState();
}

class _CalendarAndEventState extends State<CalendarAndEvent>
    with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

    // initialize event with no data.
    _events = {};

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _calendarController.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<AvailableTimeNotification>(
      child: Column(
        children: <Widget>[
          _buildTableCalendarWithBuilders(),
        ],
      ),
      onNotification: (notification) {
        _events = notification.events;
        print('length > ${notification.events.length}');
        return true;
      },
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'EN',
      calendarController: _calendarController,
      events: _events,
      initialCalendarFormat: CalendarFormat.month,
      startDay: DateTime.now(),
      formatAnimation: FormatAnimation.slide,
      availableGestures: AvailableGestures.horizontalSwipe,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle:
            TextStyle().copyWith(color: Theme.of(context).accentColor),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle:
            TextStyle().copyWith(color: Theme.of(context).accentColor),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
        leftChevronIcon: Icon(
          Icons.keyboard_arrow_left,
          color: Theme.of(context).accentColor,
        ),
        rightChevronIcon: Icon(
          Icons.keyboard_arrow_right,
          color: Theme.of(context).accentColor,
        ),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).accentColor),
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Theme.of(context).accentColor),
              width: 100,
              height: 100,
              child: Center(
                child: Text(
                  '${date.day}',
                  style:
                      TextStyle(color: Colors.white).copyWith(fontSize: 16.0),
                ),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.amber[400]),
            width: 100,
            height: 100,
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }
          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  // build event marker
  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: _calendarController.isSelected(date)
            ? BoxShape.circle
            : BoxShape.circle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Theme.of(context).accentColor,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Icon(
          Icons.done,
          color: Colors.white,
          size: 10,
        ),
      ),
    );
  }
}
