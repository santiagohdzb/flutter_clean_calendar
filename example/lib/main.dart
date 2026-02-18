import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/event_dto.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState(DateTime.now());
  }
}

class _CalendarScreenState extends State<CalendarScreen> {
  _CalendarScreenState(this._selectedDay);

  void _handleNewDate(date) {
    setState(() {
      _selectedDay = date;
      _selectedEvents = _events[_selectedDay] ?? [];
    });
    print(_selectedEvents);
  }

  List<EventDto> _selectedEvents = [];
  DateTime _selectedDay;

  final Map<DateTime, List<EventDto>> _events = {
    DateTime(2026, 1, 1): [
      EventDto() ..name = 'Event A' .. isDone = true,
    ],

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
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add transaction',
            onPressed: () { },
          ),

          IconButton(
            icon: const Icon(Icons.today),
            tooltip: 'Jump to today',
            onPressed: () { },
          ),

          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "PickDate") {
                _selectDate(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'PickDate',
                  child: Text('Pick a date')
                )
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Calendar(
                  events: _events,
                  initialDate: _selectedDay,
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime(2000), // Earliest date allowed
      lastDate: DateTime(2100),  // Latest date allowed
    );

    // If the user didn't cancel and picked a new date
    if (picked != null && picked != _selectedDay) {
      setState(() {
        _selectedDay = picked;
      });
    }
  }
}

void main() {
  runApp(MaterialApp(home: Scaffold(body: CalendarScreen())));
}