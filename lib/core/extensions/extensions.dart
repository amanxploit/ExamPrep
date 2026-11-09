import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);
  
  bool isSameDay(DateTime other) => 
    year == other.year && month == other.month && day == other.day;
  
  bool isToday() => isSameDay(DateTime.now().dateOnly);
  
  bool isYesterday() => isSameDay(DateTime.now().dateOnly.subtract(const Duration(days: 1)));
  
  int daysBetween(DateTime other) => 
    dateOnly.difference(other.dateOnly).inDays;
  
  int daysUntil(DateTime future) => 
    future.dateOnly.difference(dateOnly).inDays;
  
  String formatMMMd() => DateFormat('MMM d, yyyy').format(this);
  
  String formatMMMdYYYY() => DateFormat('MMM d, yyyy').format(this);
  
  String formatTime() => DateFormat('h:mm a').format(this);
  
  String formatShortTime() => DateFormat('HH:mm').format(this);
  
  String get weekdayInitial => DateFormat('E').format(this)[0];
  
  DateTime get startOfDay => DateTime(year, month, day);
  
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);
  
  bool get isInFuture => isAfter(DateTime.now());
  
  bool get isInPast => isBefore(DateTime.now());
}

extension DurationExtensions on Duration {
  String formatHoursMinutes() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }
  
  String formatMinutesSeconds() {
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
  
  String formatMMSS() {
    final minutes = inMinutes.toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

extension StringExtensions on String {
  String capitalize() => 
    isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  
  String sentenceCase() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

extension ListExtensions<T> on List<T> {
  List<List<T>> chunk(int size) {
    if (size <= 0) throw ArgumentError('Size must be positive');
    final result = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      result.add(sublist(i, math.min(i + size, length)));
    }
    return result;
  }
}

extension ColorExtensions on Color {
  Color withOpacity85() => withOpacity(0.85);
  Color withOpacity70() => withOpacity(0.70);
  Color withOpacity30() => withOpacity(0.30);
  Color withOpacity8() => withOpacity(0.08);
  Color withOpacity35() => withOpacity(0.35);
}

extension BuildContextExtensions on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get statusBarHeight => MediaQuery.of(this).padding.top;
  double get bottomInset => MediaQuery.of(this).viewInsets.bottom;
  bool get isKeyboardOpen => MediaQuery.of(this).viewInsets.bottom > 0;
}

extension IterableExtensions<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;
}