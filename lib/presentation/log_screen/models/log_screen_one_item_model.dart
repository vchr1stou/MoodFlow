import '../../../core/app_export.dart';
import 'package:easy_localization/easy_localization.dart';

/// This class is used in the [log_screen_one_item_widget] screen.

// ignore_for_file: must_be_immutable
class LogScreenOneItemModel {
  LogScreenOneItemModel({this.workOne, this.workTwo, this.id}) {
    workOne = workOne ?? ImageConstant.imgGroup31;
    workTwo = workTwo ?? "lbl_work".tr();
    id = id ?? "";
  }

  String? workOne;

  String? workTwo;

  String? id;
}
