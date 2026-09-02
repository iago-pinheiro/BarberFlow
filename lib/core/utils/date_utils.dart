import 'package:intl/intl.dart';
import '../constants/app_strings.dart';

class DateUtils {
  static final _dateFormat = DateFormat('dd/MM/yyyy');
  static final _timeFormat = DateFormat('HH:mm');
  static final _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final _monthYearFormat = DateFormat('MMMM yyyy');
  static final _dayOfWeekFormat = DateFormat('EEE', 'pt_BR');

  static String formatDate(DateTime date) => _dateFormat.format(date);

  static String formatTime(DateTime date) => _timeFormat.format(date);

  static String formatDateTime(DateTime date) => _dateTimeFormat.format(date);

  static String formatMonthYear(DateTime date) => _monthYearFormat.format(date);

  static String formatDayOfWeek(DateTime date) => _dayOfWeekFormat.format(date);

  static String formatDateRange(DateTime start, DateTime end) {
    if (start.month == end.month && start.year == end.year) {
      return '${formatDate(start)} a ${formatDate(end)}';
    }
    return '${formatDate(start)} - ${formatDate(end)}';
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  static bool isPast(DateTime date) {
    final now = DateTime.now();
    return date.isBefore(now);
  }

  static bool isInFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  static List<DateTime> getDaysInMonth(int year, int month) {
    final days = <DateTime>[];
    final daysInMonth = DateTime(year, month + 1, 0).day;
    for (var i = 1; i <= daysInMonth; i++) {
      days.add(DateTime(year, month, i));
    }
    return days;
  }

  static List<DateTime> getAvailableSlots(
    DateTime date,
    List<String> availableTimes,
  ) {
    return availableTimes.map((time) {
      final parts = time.split(':');
      return DateTime(date.year, date.month, date.day,
          int.parse(parts[0]), int.parse(parts[1]));
    }).toList();
  }

  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes${AppStrings.minutes}';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) {
      return '$hours hora${hours > 1 ? 's' : ''}';
    }
    return '$hours h $mins${AppStrings.minutes}';
  }
}