import 'package:flutter/material.dart';
import 'event_dto.dart';
import 'flutter_clean_calendar.dart';

class CalendarTile extends StatelessWidget {
  final VoidCallback? onDateSelected;
  final DateTime? date;
  final DaySubtitleTextBuilder? daySubtitleTextBuilder;
  final String? dayOfWeek;
  final bool isDayOfWeek;
  final bool isSelected;
  final bool inMonth;
  final List<EventDto>? events;
  final TextStyle? dayOfWeekStyles;
  final TextStyle? dateStyles;
  final Widget? child;
  final Color? selectedColor;
  final Color? eventColor;
  final Color? eventDoneColor;
  final bool circleShapeSelection;

  CalendarTile({
    this.onDateSelected,
    this.date,
    this.child,
    this.dateStyles,
    this.dayOfWeek,
    this.dayOfWeekStyles,
    this.isDayOfWeek: false,
    this.isSelected: false,
    this.inMonth: true,
    this.events,
    this.selectedColor,
    this.eventColor,
    this.eventDoneColor,
    this.circleShapeSelection = true,
    this.daySubtitleTextBuilder
  });

  Widget renderDateOrDayOfWeek(BuildContext context) {
    if (isDayOfWeek) {
      return new InkWell(
        child: new Container(
          alignment: Alignment.center,
          child: new Text(
            dayOfWeek ?? "N/A",
            style: dayOfWeekStyles,
          ),
        ),
      );
    } else {
      var subtitle = Container() as Widget;
      var now = DateTime.now();
      var isToday = new DateTime(now.year, now.month, now.day) == date!;
      var eventIndicators = <Widget>[];

      if (this.daySubtitleTextBuilder != null) {
        var subtitleDetail = this.daySubtitleTextBuilder!(context, date!);
        var color = inMonth ? Colors.black : Colors.grey;

        color = subtitleDetail.color == null ? color : subtitleDetail.color!;

        subtitle = Text(
          subtitleDetail.subtitle,
          style: TextStyle(
            fontSize: 10.0,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        );
      }

      if ((events?.length ?? 0) > 0)
      {
        var eventsSummary = <EventDto>[];
        var allEvents = events!;

        if (allEvents.length <= 3) {
          eventsSummary = allEvents;
        }
        else 
        {
          // 1. Separate into two buckets
          final doneEvents = allEvents.where((e) => e.isDone == true).toList();
          final pendingEvents = allEvents.where((e) => e.isDone != true).toList();

          // 2. Calculate how many "Done" slots we should show (out of 3)
          // Logic: (count / total) * 3, then rounded
          double doneRatio = doneEvents.length / allEvents.length;
          int doneCount = (doneRatio * 3).round();

          // 3. Handle edge cases (ensure we don't pick 0 if the list isn't empty)
          if (doneCount == 0 && doneEvents.isNotEmpty) doneCount = 1;
          if (doneCount == 3 && pendingEvents.isNotEmpty) doneCount = 2;

          int pendingCount = 3 - doneCount;

          // 4. Combine the results
          eventsSummary = [
            ...doneEvents.take(doneCount),
            ...pendingEvents.take(pendingCount),
          ];
        }

        for (int i = 0; i < eventsSummary.length; i++) {
          eventIndicators.add(Container(
            margin:
                EdgeInsets.only(left: 1.5, right: 1.5, top: 3, bottom: 3),
            width: 4.5,
            height: 4.5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: eventsSummary[i].isDone == true
                  ? eventDoneColor ?? Theme.of(context).primaryColor
                  : eventColor ?? Theme.of(context).colorScheme.onTertiary,
            ),
          ));
        }
      }

      return InkWell(
        onTap: onDateSelected,
        child: Container(
          decoration: isSelected
              ? BoxDecoration(
                  shape: this.circleShapeSelection ? BoxShape.circle  : BoxShape.rectangle,
                  color: selectedColor != null
                      ? selectedColor
                      : Theme.of(context).primaryColor,
                )
              : BoxDecoration(),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5.0),
              Text(
                date!.day.toString(),
                style: TextStyle(
                  fontSize: 14.0,
                  fontStyle: isToday ? FontStyle.italic : FontStyle.normal,
                  fontWeight: isToday ? FontWeight.w900 : FontWeight.w400,
                  color: inMonth ? Colors.black : Colors.grey),
              ),
              eventIndicators.length > 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: eventIndicators
                  )
                : Container(),
              subtitle,
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return new InkWell(
        child: child,
        onTap: onDateSelected,
      );
    }
    return new Container(
      child: renderDateOrDayOfWeek(context),
    );
  }
}
