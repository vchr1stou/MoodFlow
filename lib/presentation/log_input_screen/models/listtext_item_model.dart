import '../../../core/app_export.dart';

/// This class is used in the [listtext_item_widget] screen.

// ignore_for_file: must_be_immutable
class ListtextItemModel {
  ListtextItemModel({this.image, this.text, this.chatyourfeels, this.id}) {
    image = image ?? ImageConstant.imgIosIcon;
    text = text ?? "lbl_text".tr;
    chatyourfeels = chatyourfeels ?? "msg_chat_your_feels".tr;
    id = id ?? "";
  }

  String? image;

  String? text;

  String? chatyourfeels;

  String? id;
}
