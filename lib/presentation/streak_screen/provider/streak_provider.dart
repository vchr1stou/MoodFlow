import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import '../../../core/app_export.dart';
import '../models/streak_model.dart';

/// A provider class for the StreakScreen.
///
/// This provider manages the state of the StreakScreen, including the
/// current streakModelObj

// ignore_for_file: must_be_immutable
class StreakProvider extends ChangeNotifier {
  StreakModel streakModelObj = StreakModel();
  List<DateTime?>? selectedDatesFromCalendar;

  @override
  void dispose() {
    super.dispose();
  }
}
