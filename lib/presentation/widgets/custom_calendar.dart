import 'package:extended_image/extended_image.dart';
import 'package:f1_pet_project/domain/help/extensions.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ignore_for_file: avoid_annotating_with_dynamic
import 'package:table_calendar/table_calendar.dart';

// TODO(pavlov): добавить отображение выбранной даты на календарь
// TODO(pavlov): добавить отображение количества событий, если их несколько
class CustomCalendar extends StatefulWidget {
  final DateTime selectedDay;
  final DateTime focusedDay;

  final void Function(DateTime firstDay) onPageChanged;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final String? Function(DateTime day) imagePathCallback;

  const CustomCalendar({
    required this.selectedDay,
    required this.onPageChanged,
    required this.imagePathCallback,
    required this.onDaySelected,
    DateTime? focusedDay,
    Key? key,
  })  : focusedDay = focusedDay ?? selectedDay,
        super(key: key);

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  @override
  Widget build(BuildContext context) {
    const textStyle = AppStyles.body;

    return ColoredBox(
      color: AppTheme.grey,
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
            return day.month == focusedDay.month
                ? _makeLogoWidget(
                      day,
                      isSelected: true,
                    ) ??
                    _makeTextWidget(
                      day,
                      textStyle: textStyle,
                      isSelected: true,
                    )
                : _makeTextWidget(
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
            return _makeLogoWidget(day) ??
                _makeTextWidget(
                  day,
                  textStyle: textStyle.copyWith(
                    color: day.month == focusedDay.month
                        ? null
                        : AppTheme.turquoise,
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

  Widget? _makeLogoWidget(
    DateTime date, {
    bool isSelected = false,
  }) {
    final imageAsset = widget.imagePathCallback(date);

    if (imageAsset != null) {
      return Center(
        child: CircleAvatar(
          radius: 16,
          backgroundColor: isSelected ? AppTheme.red : Colors.transparent,
          child: imageAsset.isEmpty
              ? const SizedBox(
                  height: 24,
                  child: Icon(Icons.home),
                )
              : SizedBox(
                  height: 24,
                  child: ExtendedImage.asset(imageAsset),
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
  }) {
    return Center(
      child: CircleAvatar(
        radius: 16,
        backgroundColor: isSelected ? AppTheme.red : Colors.transparent,
        child: Text(
          date.day.toString(),
          style: textStyle,
        ),
      ),
    );
  }
}

class ChevronButton extends StatelessWidget {
  final IconData icon;
  final AlignmentGeometry alignment;
  const ChevronButton({
    required this.icon,
    this.alignment = Alignment.centerLeft,
    Key? key,
  }) : super(key: key);

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
