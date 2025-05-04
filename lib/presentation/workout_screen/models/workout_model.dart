import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/app_export.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';

class WorkoutModel {
  TextEditingController? durationController;
  TextEditingController? notesController;
  SelectionPopupModel? workoutType;
  SelectionPopupModel? intensity;
  
  List<SelectionPopupModel> workoutTypeItems = [
    SelectionPopupModel(id: 1, title: "lbl_cardio".tr()),
    SelectionPopupModel(id: 2, title: "lbl_strength".tr()),
    SelectionPopupModel(id: 3, title: "lbl_yoga".tr()),
    SelectionPopupModel(id: 4, title: "lbl_hiit".tr()),
    SelectionPopupModel(id: 5, title: "lbl_pilates".tr()),
  ];
  
  List<SelectionPopupModel> intensityItems = [
    SelectionPopupModel(id: 1, title: "lbl_light".tr()),
    SelectionPopupModel(id: 2, title: "lbl_moderate".tr()),
    SelectionPopupModel(id: 3, title: "lbl_intense".tr()),
  ];

  WorkoutModel() {
    durationController = TextEditingController();
    notesController = TextEditingController();
  }
}
