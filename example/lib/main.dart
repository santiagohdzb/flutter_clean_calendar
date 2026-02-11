import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/event_dto.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {
  void _handleNewDate(date) {
    setState(() {
      _selectedDay = date;
      _selectedEvents = _events[_selectedDay] ?? [];
    });
    print(_selectedEvents);
  }

  List<EventDto> _selectedEvents = [];
  DateTime? _selectedDay;

final Map<DateTime, List<EventDto>> _events = {
    DateTime(2026, 2, 1): [
      EventDto() ..name = 'Event A' .. isDone = true,
    ],
    DateTime(2026, 2, 4): [
      EventDto()..name = 'Event A'..isDone = true,
      EventDto()..name = 'Event B'..isDone = true,
    ],
    DateTime(2026, 2, 5): [
      EventDto()..name = 'Event A'..isDone = true,
      EventDto()..name = 'Event B'..isDone = true,
    ],
    DateTime(2026, 2, 10): [
      EventDto()..name = 'Event A'..isDone = true,
      EventDto()..name = 'Event B'..isDone = true,
    ],
    DateTime(2026, 2, 13): [
      EventDto()..name = 'Event A'..isDone = true,
      EventDto()..name = 'Event C'..isDone = false,
      EventDto()..name = 'Event E'..isDone = false,
      EventDto()..name = 'Event F'..isDone = false,
      EventDto()..name = 'Event B'..isDone = true,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event B'..isDone = true,
      EventDto()..name = 'Event B'..isDone = true,
      EventDto()..name = 'Event B'..isDone = true,
      EventDto()..name = 'Event B'..isDone = true,
      EventDto()..name = 'Event B'..isDone = true,
      EventDto()..name = 'Event B'..isDone = true,
      EventDto()..name = 'Event B'..isDone = true,
      EventDto()..name = 'Event B'..isDone = true,
      EventDto()..name = 'Event B'..isDone = true,
      EventDto()..name = 'Event B'..isDone = true,
      EventDto()..name = 'Event B'..isDone = true,
      EventDto()..name = 'Event B'..isDone = true,
      EventDto()..name = 'Event B'..isDone = true,
      EventDto()..name = 'Event B'..isDone = true,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
      EventDto()..name = 'Event G'..isDone = false,
    ],
    DateTime(2026, 2, 15): [
      EventDto()..name = 'Event A'..isDone = true,
      EventDto()..name = 'Event B'..isDone = true,
      EventDto()..name = 'Event C'..isDone = false,
      EventDto()..name = 'Event C'..isDone = false,
      EventDto()..name = 'Event C'..isDone = false,
    ],
    DateTime(2026, 2, 26): [
      EventDto()..name = 'Event A'..isDone = false,
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedEvents = _events[_selectedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Calendar'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Calendar(
                  events: _events,
                  onRangeSelected: (range) =>
                      print("Range is ${range.from}, ${range.to}"),
                  onDateSelected: (date) => _handleNewDate(date),
                  isExpandable: false,
                  isExpanded: true,
                  showTodayIcon: false,
                  showTopHeader: true,
                  eventDoneColor: Colors.green,
                  eventColor: Colors.grey,
                  circleShapeSelection: false,
                  daySubtitleTextBuilder: (context, date) {
                    var events = _events[date];
                    var hasEvents = events?.isNotEmpty == true;
                    var text = hasEvents ? "-9,999,999" : "";
                    return new DaySubtitleDetail(text, Colors.red);
                  },
                ),
            ),
            _buildEventList()
          ],
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.5, color: Colors.black12),
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
              child: ListTile(
                title: Text(_selectedEvents![index].name.toString()),
                onTap: () {},
              ),
            ),
        itemCount: _selectedEvents!.length,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: Scaffold(body: CalendarScreen())));
}