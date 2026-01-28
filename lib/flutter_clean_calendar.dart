library flutter_clean_calendar;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:date_utils/date_utils.dart' as DateUtils;
import './simple_gesture_detector.dart';
import './calendar_tile.dart';
import 'event_dto.dart';

typedef DayBuilder(BuildContext context, DateTime day);

class Range {
  final DateTime from;
  final DateTime to;
  Range(this.from, this.to);
}

class Calendar extends StatefulWidget {
  final ValueChanged<DateTime>? onDateSelected;
  final ValueChanged<DateTime>? onMonthChanged;
  final ValueChanged? onRangeSelected;
  final bool isExpandable;
  final DayBuilder? dayBuilder;
  final bool showArrows;
  final bool showTodayIcon;
  final Map<DateTime, List<EventDto>>? events;
  final Color? selectedColor;
  final Color? eventColor;
  final Color? eventDoneColor;
  final DateTime? initialDate;
  final bool isExpanded;

  Calendar({
    this.onMonthChanged,
    this.onDateSelected,
    this.onRangeSelected,
    this.isExpandable: false,
    this.events,
    this.dayBuilder,
    this.showTodayIcon: true,
    this.showArrows: true,
    this.selectedColor,
    this.eventColor,
    this.eventDoneColor,
    this.initialDate,
    this.isExpanded = false,
  });

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<DateTime>? selectedMonthsDays;
  Iterable<DateTime>? selectedWeeksDays;
  DateTime _selectedDate = DateTime.now();
  String? currentMonth;
  bool isExpanded = false;
  String? displayMonth;
  DateTime get selectedDate => _selectedDate;

  

  void initState() {
    super.initState();
    _selectedDate = widget?.initialDate ?? DateTime.now();
    isExpanded = widget?.isExpanded ?? false;
    selectedMonthsDays = DateUtils.DateUtils.daysInMonth(_selectedDate);
    var firstDayOfCurrentWeek = DateUtils.DateUtils.firstDayOfWeek(_selectedDate);
    var lastDayOfCurrentWeek = DateUtils.DateUtils.lastDayOfWeek(_selectedDate);
    selectedWeeksDays =
        DateUtils.DateUtils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
            .toList()
            .sublist(0, 7);
    displayMonth = DateUtils.DateUtils.formatMonth(_selectedDate);
  }

  Widget get nameAndIconRow {
    var todayIcon;
    var leftArrow;
    var rightArrow;

    if (widget.showArrows) {
      leftArrow = IconButton(
        onPressed: isExpanded ? previousMonth : previousWeek,
        icon: Icon(Icons.chevron_left),
      );
      rightArrow = IconButton(
        onPressed: isExpanded ? nextMonth : nextWeek,
        icon: Icon(Icons.chevron_right),
      );
    } else {
      leftArrow = Container();
      rightArrow = Container();
    }

    if (widget.showTodayIcon) {
      todayIcon = InkWell(
        child: Text('Today'),
        onTap: resetToToday,
      );
    } else {
      todayIcon = Container();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        leftArrow ?? Container(),
        Column(
          children: <Widget>[
            todayIcon ?? Container(),
            Text(
              displayMonth ?? "N/A",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ],
        ),
        rightArrow ?? Container(),
      ],
    );
  }

  Widget get calendarGridView {
    return Container(
      child: SimpleGestureDetector(
        key: UniqueKey(),
        onSwipeUp: _onSwipeUp,
        onSwipeDown: _onSwipeDown,
        onSwipeLeft: _onSwipeLeft,
        onSwipeRight: _onSwipeRight,
        swipeConfig: SimpleSwipeConfig(
          verticalThreshold: 10.0,
          horizontalThreshold: 40.0,
          swipeDetectionMoment: SwipeDetectionMoment.onUpdate,
        ),
        child: Column(children: <Widget>[
          GridView.count(
            primary: false,
            shrinkWrap: true,
            crossAxisCount: 7,
            padding: EdgeInsets.only(bottom: 0.0),
            children: calendarBuilder(),
          ),
        ]),
      ),
    );
  }

  List<Widget> calendarBuilder() {
    List<Widget> dayWidgets = [];
    List<DateTime>? calendarDays =
        isExpanded ? selectedMonthsDays : selectedWeeksDays?.toList();

    DateUtils.DateUtils.weekdays.forEach(
      (day) {
        dayWidgets.add(
          CalendarTile(
            selectedColor: widget.selectedColor,
            eventColor: widget.eventColor,
            eventDoneColor: widget.eventDoneColor,
            events: widget.events![day],
            isDayOfWeek: true,
            dayOfWeek: day,
          ),
        );
      },
    );

    bool monthStarted = false;
    bool monthEnded = false;

    calendarDays!.forEach(
      (day) {
        if (day.hour > 0) {
          day = day.toLocal();

          day = day.subtract(new Duration(hours: day.hour));
        }

        if (monthStarted && day.day == 01) {
          monthEnded = true;
        }

        if (DateUtils.DateUtils.isFirstDayOfMonth(day)) {
          monthStarted = true;
        }

        if (this.widget.dayBuilder != null) {
          dayWidgets.add(
            CalendarTile(
              selectedColor: widget.selectedColor,
              eventColor: widget.eventColor,
              eventDoneColor: widget.eventDoneColor,
              events: widget.events![day],
              child: this.widget.dayBuilder!(context, day),
              date: day,
              onDateSelected: () => handleSelectedDateAndUserCallback(day),
            ),
          );
        } else {
          dayWidgets.add(
            CalendarTile(
                selectedColor: widget.selectedColor,
                eventColor: widget.eventColor,
                eventDoneColor: widget.eventDoneColor,
                events: widget.events![day],
                onDateSelected: () => handleSelectedDateAndUserCallback(day),
                date: day,
                dateStyles: configureDateStyle(monthStarted, monthEnded),
                isSelected: DateUtils.DateUtils.isSameDay(selectedDate, day),
                inMonth: day.month == selectedDate.month),
          );
        }
      },
    );
    return dayWidgets;
  }

  TextStyle configureDateStyle(monthStarted, monthEnded) {
    TextStyle dateStyles;
    final TextStyle body1Style = Theme.of(context).textTheme.bodyMedium!;

    if (isExpanded) {
      final TextStyle body1StyleDisabled = body1Style.copyWith(
          color: Color.fromARGB(
        100,
        body1Style.color!.r.toInt(),
        body1Style.color!.g.toInt(),
        body1Style.color!.b.toInt(),
      ));

      dateStyles =
          monthStarted && !monthEnded ? body1Style : body1StyleDisabled;
    } else {
      dateStyles = body1Style;
    }
    return dateStyles;
  }

  Widget get expansionButtonRow {
    if (widget.isExpandable) {
      return GestureDetector(
        onTap: toggleExpanded,
        child: Container(
          color: Color.fromRGBO(0, 0, 0, 0.07),
          height: 40,
          margin: EdgeInsets.only(top: 8.0),
          padding: EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(width: 40.0),
              Text(DateUtils.DateUtils.fullDayFormat(selectedDate)),
              IconButton(
                onPressed: () {},
                iconSize: 20.0,
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                icon: isExpanded
                    ? Icon(Icons.arrow_drop_up)
                    : Icon(Icons.arrow_drop_down),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          nameAndIconRow,
          ExpansionCrossFade(
            collapsed: calendarGridView,
            expanded: calendarGridView,
            isExpanded: isExpanded,
          ),
          expansionButtonRow
        ],
      ),
    );
  }

  void resetToToday() {
    _selectedDate = DateTime.now();
    var firstDayOfCurrentWeek = DateUtils.DateUtils.firstDayOfWeek(_selectedDate);
    var lastDayOfCurrentWeek = DateUtils.DateUtils.lastDayOfWeek(_selectedDate);

    setState(() {
      selectedWeeksDays =
          DateUtils.DateUtils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList();
      selectedMonthsDays = DateUtils.DateUtils.daysInMonth(_selectedDate);
      displayMonth = DateUtils.DateUtils.formatMonth(_selectedDate);
    });

    _launchDateSelectionCallback(_selectedDate);
  }

  void nextMonth() {
    setState(() {
      _selectedDate = DateUtils.DateUtils.nextMonth(_selectedDate);
      var firstDateOfNewMonth = DateUtils.DateUtils.firstDayOfMonth(_selectedDate);
      var lastDateOfNewMonth = DateUtils.DateUtils.lastDayOfMonth(_selectedDate);
      updateSelectedRange(firstDateOfNewMonth, lastDateOfNewMonth);
      selectedMonthsDays = DateUtils.DateUtils.daysInMonth(_selectedDate);
      displayMonth = DateUtils.DateUtils.formatMonth(_selectedDate);
    });

    if (widget.onMonthChanged != null) {
      widget.onMonthChanged!(_selectedDate);
    }
  }

  void previousMonth() {
    setState(() {
      _selectedDate = DateUtils.DateUtils.previousMonth(_selectedDate);
      var firstDateOfNewMonth = DateUtils.DateUtils.firstDayOfMonth(_selectedDate);
      var lastDateOfNewMonth = DateUtils.DateUtils.lastDayOfMonth(_selectedDate);
      updateSelectedRange(firstDateOfNewMonth, lastDateOfNewMonth);
      selectedMonthsDays = DateUtils.DateUtils.daysInMonth(_selectedDate);
      displayMonth = DateUtils.DateUtils.formatMonth(_selectedDate);
    });

    if (widget.onMonthChanged != null) {
      widget.onMonthChanged!(_selectedDate);
    }
  }

  void nextWeek() {
    setState(() {
      _selectedDate = DateUtils.DateUtils.nextWeek(_selectedDate);
      var firstDayOfCurrentWeek = DateUtils.DateUtils.firstDayOfWeek(_selectedDate);
      var lastDayOfCurrentWeek = DateUtils.DateUtils.lastDayOfWeek(_selectedDate);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeeksDays =
          DateUtils.DateUtils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList()
              .sublist(0, 7);
      displayMonth = DateUtils.DateUtils.formatMonth(_selectedDate);
    });
    _launchDateSelectionCallback(_selectedDate);
  }

  void previousWeek() {
    setState(() {
      _selectedDate = DateUtils.DateUtils.previousWeek(_selectedDate);
      var firstDayOfCurrentWeek = DateUtils.DateUtils.firstDayOfWeek(_selectedDate);
      var lastDayOfCurrentWeek = DateUtils.DateUtils.lastDayOfWeek(_selectedDate);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeeksDays =
          DateUtils.DateUtils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList()
              .sublist(0, 7);
      displayMonth = DateUtils.DateUtils.formatMonth(_selectedDate);
    });
    _launchDateSelectionCallback(_selectedDate);
  }

  void updateSelectedRange(DateTime start, DateTime end) {
    Range _rangeSelected = Range(start, end);
    if (widget.onRangeSelected != null) {
      widget.onRangeSelected!(_rangeSelected);
    }
  }

  void _onSwipeUp() {
    if (isExpanded) toggleExpanded();
  }

  void _onSwipeDown() {
    if (!isExpanded) toggleExpanded();
  }

  void _onSwipeRight() {
    if (isExpanded) {
      previousMonth();
    } else {
      previousWeek();
    }
  }

  void _onSwipeLeft() {
    if (isExpanded) {
      nextMonth();
    } else {
      nextWeek();
    }
  }

  void toggleExpanded() {
    if (widget.isExpandable) {
      setState(() => isExpanded = !isExpanded);
    }
  }

  void handleSelectedDateAndUserCallback(DateTime day) {
    var firstDayOfCurrentWeek = DateUtils.DateUtils.firstDayOfWeek(day);
    var lastDayOfCurrentWeek = DateUtils.DateUtils.lastDayOfWeek(day);
    if (_selectedDate.month > day.month) {
      previousMonth();
    }
    if (_selectedDate.month < day.month) {
      nextMonth();
    }
    setState(() {
      _selectedDate = day;
      selectedWeeksDays =
          DateUtils.DateUtils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList();
      selectedMonthsDays = DateUtils.DateUtils.daysInMonth(day);
    });
    _launchDateSelectionCallback(day);
  }

  void _launchDateSelectionCallback(DateTime day) {
    if (widget.onDateSelected != null) {
      widget.onDateSelected!(day);
    }
  }
}

class ExpansionCrossFade extends StatelessWidget {
  final Widget? collapsed;
  final Widget? expanded;
  final bool? isExpanded;

  ExpansionCrossFade({this.collapsed, this.expanded, this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: AnimatedCrossFade(
        firstChild: collapsed!,
        secondChild: expanded!,
        firstCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.decelerate,
        crossFadeState:
            isExpanded! ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}
