import '../../../core/app_export.dart';

/// This class is used in the [history_preview_item_widget] screen.

// ignore_for_file: must_be_immutable
class HistoryPreviewItemModel {
  HistoryPreviewItemModel({this.bagOne, this.work, this.id}) {
    bagOne = bagOne ?? ImageConstant.imgBag;
    work = work ?? "lbl_work".tr;
    id = id ?? "";
  }

  String? bagOne;

  String? work;

  String? id;
}
