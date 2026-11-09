import 'package:intl/intl.dart';
import '../extensions/extensions.dart';

class AppDateUtils {
  static final _dateFormat = DateFormat('MMM d, yyyy');
  static final _timeFormat = DateFormat('h:mm a');
  static final _shortTimeFormat = DateFormat('HH:mm');
  static final _weekdayFormat = DateFormat('E');
  static final _monthDayFormat = DateFormat('MMM d');

  static String formatDate(DateTime date) => _dateFormat.format(date);

  static String formatTime(DateTime date) => _timeFormat.format(date);

  static String formatShortTime(DateTime date) => _shortTimeFormat.format(date);

  static String weekdayInitial(DateTime date) => _weekdayFormat.format(date)[0];

  static String monthDay(DateTime date) => _monthDayFormat.format(date);

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  static String formatMinutesSeconds(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  static String formatMMSS(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  static int daysBetween(DateTime start, DateTime end) {
    return start.dateOnly.difference(end.dateOnly).inDays.abs();
  }

  static int daysUntil(DateTime future) {
    return future.dateOnly.difference(DateTime.now().dateOnly).inDays;
  }

  static List<DateTime> last7Days({DateTime? endDate}) {
    final end = (endDate ?? DateTime.now()).dateOnly;
    return List.generate(7, (i) => end.subtract(Duration(days: 6 - i)));
  }

  static List<String> last7DayLabels({DateTime? endDate}) {
    return last7Days(endDate: endDate).map(weekdayInitial).toList();
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59);
}
