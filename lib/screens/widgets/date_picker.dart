import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DatePicker {
  static Future<DateTime?> show({
    required BuildContext context,
    required DateTime? initialDate,
    required bool isJoinDate,
    DateTime? joinDate,
  }) async {
    DateTime validInitialDate = (initialDate != null && initialDate.isAfter(DateTime(2000))) ? initialDate : DateTime.now();
    DateTime? tempDate = validInitialDate;

    DateTime? pickedDate = await showDialog<DateTime?>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 16),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      _quickSelectButton(context, "Today", DateTime.now(), setState, (date) {
                        setState(() => tempDate = date);
                      }, tempDate),
                      if (!isJoinDate)
                        _quickSelectButton(context, "No Date", null, setState, (date) {
                          setState(() => tempDate = null);
                        }, tempDate),
                      if (isJoinDate) ...[
                        _quickSelectButton(context, "Next Monday", _nextWeekday(DateTime.now(), DateTime.monday), setState, (date) {
                          setState(() => tempDate = date);
                        }, tempDate),
                        _quickSelectButton(context, "Next Tuesday", _nextWeekday(DateTime.now(), DateTime.tuesday), setState, (date) {
                          setState(() => tempDate = date);
                        }, tempDate),
                        _quickSelectButton(context, "After 1 week", DateTime.now().add(Duration(days: 7)), setState, (date) {
                          setState(() => tempDate = date);
                        }, tempDate),
                      ],
                    ],
                  ),
                  SizedBox(height: 8),
                  TableCalendar(
                    focusedDay: tempDate ?? DateTime.now(),
                    firstDay: DateTime(2000),
                    lastDay: DateTime(2100),
                    selectedDayPredicate: tempDate != null ? (day) => isSameDay(tempDate, day) : (day) => false,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() => tempDate = selectedDay);
                    },
                    calendarFormat: CalendarFormat.month,
                    availableCalendarFormats: {CalendarFormat.month: 'Month'},
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              actions: [
                Row(
                  children: [
                    // Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary, size: 16),
                    Image.asset(
                      'assets/calendar_icon.png',
                      width: 16,
                      height: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 5),
                    Text(
                      tempDate != null ? DateFormat('d MMM yyyy').format(tempDate!) : "No Date",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                    ),
                    SizedBox(width: 5),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onPressed: () {
                        if (!isJoinDate && tempDate != null && tempDate!.isBefore(DateTime.now())) {
                          Fluttertoast.showToast(
                            msg: "Leave date cannot be before joining date",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                          );
                          return;
                        }
                        Navigator.pop(context, tempDate);
                      },
                      child: Text("Save"),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );

    return pickedDate;
  }

  static Widget _quickSelectButton(
    BuildContext context,
    String label,
    DateTime? date,
    StateSetter setState,
    Function(DateTime?) onSelected,
    DateTime? selectedDate,
  ) {
    bool isSelected =
        (date == null && selectedDate == null) || (date != null && selectedDate != null && selectedDate.year == date.year && selectedDate.month == date.month && selectedDate.day == date.day);

    return SizedBox(
      width: 120,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            onSelected(date);
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: Text(
          label,
          style: TextStyle(color: isSelected ? Colors.white : Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  static DateTime _nextWeekday(DateTime date, int weekday) {
    int daysToAdd = (weekday - date.weekday + 7) % 7;
    return date.add(Duration(days: daysToAdd == 0 ? 7 : daysToAdd));
  }
}
