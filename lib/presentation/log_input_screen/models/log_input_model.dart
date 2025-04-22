import '../../../core/app_export.dart';
import 'listtext_item_model.dart';

// ignore_for_file: must_be_immutable
class LogInputModel {
  List<ListtextItemModel> listtextItemList = [
    ListtextItemModel(
        image: ImageConstant.imgIosIcon,
        text: "lbl_text".tr,
        chatyourfeels: "msg_chat_your_feels".tr),
    ListtextItemModel(
        image: ImageConstant.img,
        text: "lbl_emojis".tr,
        chatyourfeels: "msg_feeling_emoji_nal".tr),
    ListtextItemModel(
        image: ImageConstant.imgGroup25,
        text: "lbl_colors".tr,
        chatyourfeels: "msg_paint_your_mood_choose".tr)
  ];
}
