import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/workout_model.dart';

/// A provider class for the WorkoutScreen.
///
/// This provider manages the state of the WorkoutScreen, including the
/// current workoutModelObj
// ignore_for_file: must_be_immutable
class WorkoutProvider extends ChangeNotifier {
  TextEditingController searchfieldoneController = TextEditingController();
  WorkoutModel workoutModelObj = WorkoutModel();

  @override
  void dispose() {
    searchfieldoneController.dispose();
    super.dispose();
  }
}
