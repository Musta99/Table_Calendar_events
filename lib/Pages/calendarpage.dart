import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  TextEditingController eventController = TextEditingController();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime? _tapedDate;
  DateTime today = DateTime.now();
  Map<DateTime, List> events = {};

  void addEvents() {
    events[_tapedDate!] ??= [];
    events[_tapedDate]!.add(eventController.text);
    eventController.clear();
  }

  List getEventsOnTapedDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          addEvents();
          setState(() {
            events[_tapedDate];
          });
          print("Event added");
        },
        label: Text("Add events"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SingleChildScrollView(
              child: TableCalendar(
                eventLoader: getEventsOnTapedDay,
                calendarFormat: _calendarFormat,
                focusedDay: today,
                firstDay: DateTime.utc(2010),
                lastDay: DateTime.utc(2050),
                selectedDayPredicate: (day) {
                  return isSameDay(_tapedDate, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _tapedDate = selectedDay;
                  });
                  print(_tapedDate);
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                  ;
                },
              ),
            ),
            TextField(
              controller: eventController,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
              )),
            ),
            Expanded(
              child: events[_tapedDate] != null
                  ? ListView.builder(
                      itemCount: events[_tapedDate]!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Color.fromARGB(255, 165, 188, 207),
                                width: 1),
                          ),
                          title: Text(
                            events[_tapedDate]![index],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "No events to show",
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
