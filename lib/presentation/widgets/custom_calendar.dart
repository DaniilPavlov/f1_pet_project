import 'package:f1_pet_project/domain/help/string_extensions.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({
    required this.selectedDay,
    required this.onPageChanged,
    required this.imagePathCallback,
    required this.onDaySelected,
    DateTime? focusedDay,
    super.key,
  }) : focusedDay = focusedDay ?? selectedDay;
  final DateTime selectedDay;
  final DateTime focusedDay;

  final void Function(DateTime firstDay) onPageChanged;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final String? Function(DateTime day) imagePathCallback;

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  Widget? _makeLogoWidget(
    DateTime date, {
    bool isSelected = false,
    bool isToday = false,
  }) {
    final imageAsset = widget.imagePathCallback(date);

    if (imageAsset != null) {
      return Center(
        child: CircleAvatar(
          radius: 16,
          backgroundColor: isToday
              ? AppTheme.red
              : isSelected
                  ? AppTheme.white
                  : Colors.transparent,
          child: imageAsset.isEmpty
              ? const SizedBox(
                  height: 24,
                  child: Icon(Icons.home),
                )
              : SizedBox(
                  height: 24,
                  child: Image.asset(imageAsset),
                ),
        ),
      );
    }
    return null;
  }

  Widget _makeTextWidget(
    DateTime date, {
    required TextStyle textStyle,
    bool isSelected = false,
    bool isToday = false,
  }) {
    return Center(
      child: CircleAvatar(
        radius: 16,
        backgroundColor: isToday
            ? AppTheme.red
            : isSelected
                ? AppTheme.white
                : Colors.transparent,
        child: Text(
          date.day.toString(),
          style: textStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = AppStyles.body;

    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        color: AppTheme.shadowColor,
      ),
      child: TableCalendar<dynamic>(
        locale: 'ru_RU',
        availableGestures: AvailableGestures.horizontalSwipe,
        firstDay: DateTime.utc(DateTime.now().year - 1, 1, 1),
        lastDay: DateTime.utc(DateTime.now().year + 1, 1, 1),
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
            final text = DateFormat.yMMMM('ru_RU').format(date);

            return text.capitalize();
          },
        ),
        calendarBuilders: CalendarBuilders<dynamic>(
          selectedBuilder: (context, day, focusedDay) {
            return _makeLogoWidget(
                  day,
                  isSelected: true,
                ) ??
                _makeTextWidget(
                  day,
                  textStyle: textStyle,
                  isSelected: true,
                );
          },
          outsideBuilder: (context, day, focusedDay) {
            return day.month == focusedDay.month
                ? _makeLogoWidget(day) ??
                    _makeTextWidget(
                      day,
                      textStyle: textStyle.copyWith(
                        color: AppTheme.white,
                      ),
                    )
                : _makeTextWidget(
                    day,
                    textStyle: textStyle.copyWith(
                      color: AppTheme.white,
                    ),
                  );
          },
          todayBuilder: (context, day, focusedDay) {
            return _makeLogoWidget(
                  day,
                  isToday: true,
                ) ??
                _makeTextWidget(
                  day,
                  isToday: true,
                  textStyle: textStyle.copyWith(
                    color:
                        day.month == focusedDay.month ? null : AppTheme.white,
                  ),
                );
          },
          defaultBuilder: (context, day, focusedDay) {
            return _makeLogoWidget(day);
          },
        ),
      ),
    );
  }
}

class ChevronButton extends StatelessWidget {
  const ChevronButton({
    required this.icon,
    this.alignment = Alignment.centerLeft,
    super.key,
  });
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
