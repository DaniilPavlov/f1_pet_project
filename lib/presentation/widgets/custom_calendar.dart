import 'package:f1_pet_project/domain/help/extensions.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ignore_for_file: avoid_annotating_with_dynamic
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({
    required this.selectedDay,
    required this.onPageChanged,
    required this.imagePathCallback,
    required this.onDaySelected,
    DateTime? focusedDay,
    Key? key,
  })  : focusedDay = focusedDay ?? selectedDay,
        super(key: key);
  final DateTime selectedDay;
  final DateTime focusedDay;

  final void Function(DateTime firstDay) onPageChanged;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final String? Function(DateTime day) imagePathCallback;

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  @override
  Widget build(BuildContext context) {
    const textStyle = AppStyles.body;

    return Container(
      color: AppTheme.grayBG,
      child: TableCalendar<dynamic>(
        locale: 'ru_RU',
        availableGestures: AvailableGestures.horizontalSwipe,
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: widget.focusedDay,
        rowHeight: 48,
        daysOfWeekHeight: 40,
        startingDayOfWeek: StartingDayOfWeek.monday,
        selectedDayPredicate: (day) {
          return isSameDay(widget.selectedDay, day);
        },
        onPageChanged: widget.onPageChanged,
        onDaySelected: widget.onDaySelected,
        calendarStyle: const CalendarStyle(
          defaultTextStyle: textStyle,
          holidayTextStyle: textStyle,
          selectedTextStyle: textStyle,
          weekendTextStyle: textStyle,
          cellMargin: EdgeInsets.zero,
          markerMargin: EdgeInsets.zero,
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: textStyle,
          weekendStyle: textStyle,
        ),
        headerStyle: HeaderStyle(
          titleTextStyle: textStyle,
          formatButtonVisible: false,
          titleCentered: true,
          rightChevronPadding: EdgeInsets.zero,
          leftChevronPadding: EdgeInsets.zero,
          leftChevronIcon: const ChevronButton(
            icon: Icons.arrow_left,
          ),
          rightChevronIcon: const ChevronButton(
            icon: Icons.arrow_right,
            alignment: Alignment.centerRight,
          ),
          titleTextFormatter: (date, dynamic f) {
            final text = DateFormat('MMMM', 'ru_RU').format(date);

            return text.capitalize();
          },
        ),
        calendarBuilders: CalendarBuilders<dynamic>(
          selectedBuilder: (context, day, focusedDay) {
            return _makeTextWidget(
              day,
              textStyle: textStyle.copyWith(color: Colors.white),
              isSelected: true,
            );
          },
          outsideBuilder: (context, day, focusedDay) {
            return const SizedBox();
          },
          todayBuilder: (context, day, focusedDay) {
            return _makeTextWidget(
              day,
              textStyle: textStyle.copyWith(
                color: day.month == focusedDay.month ? null : AppTheme.black,
              ),
            );
          },
          defaultBuilder: (context, day, focusedDay) {
            return _makeTextWidget(
              day,
              textStyle: textStyle.copyWith(
                color: day.month == focusedDay.month ? null : AppTheme.black,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _makeTextWidget(
    DateTime date, {
    required TextStyle textStyle,
    bool isSelected = false,
  }) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: isSelected ? AppTheme.red : Colors.transparent,
            child: Text(
              date.day.toString(),
              style: textStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: CircleAvatar(
              radius: 2,
              backgroundColor: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class ChevronButton extends StatelessWidget {
  const ChevronButton({
    required this.icon,
    this.alignment = Alignment.centerLeft,
    Key? key,
  }) : super(key: key);
  final IconData icon;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 30,
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            icon,
            color: Colors.black,
            // size: 15,
          ),
        ),
      ),
    );
  }
}
