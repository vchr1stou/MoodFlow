import '../../../core/app_export.dart';

/// This class is used in the [listcooking_one_item_widget] screen.

// ignore_for_file: must_be_immutable
class ListcookingOneItemModel {
  ListcookingOneItemModel(
      {this.cookingOne, this.cookingTwo, this.description, this.id}) {
    cookingOne = cookingOne ?? ImageConstant.imgFryingPanFill;
    cookingTwo = cookingTwo ?? "lbl_cooking".tr;
    description = description ?? "msg_cooking_blends_creativity".tr;
    id = id ?? "";
  }

  String? cookingOne;

  String? cookingTwo;

  String? description;

  String? id;
}
