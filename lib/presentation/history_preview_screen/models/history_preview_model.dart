import '../../../core/app_export.dart';
import 'history_preview_item_model.dart';

// ignore_for_file: must_be_immutable
class HistoryPreviewModel {
  List<HistoryPreviewItemModel> historyPreviewItemList = [
    HistoryPreviewItemModel(bagOne: ImageConstant.imgBag, work: "lbl_work".tr),
    HistoryPreviewItemModel(
        bagOne: ImageConstant.imgMusicNote2, work: "lbl_music".tr),
    HistoryPreviewItemModel(
        bagOne: ImageConstant.imgBooksVerticalFill, work: "lbl_study".tr),
    HistoryPreviewItemModel(work: "lbl_person1".tr),
    HistoryPreviewItemModel(work: "lbl_person2".tr),
    HistoryPreviewItemModel(),
    HistoryPreviewItemModel(),
    HistoryPreviewItemModel(),
    HistoryPreviewItemModel()
  ];
}
