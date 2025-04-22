import '../../../core/app_export.dart';

/// This class is used in the [softthanks_one_item_widget] screen.
/// It represents a single gratitude item in the soft thanks list.
// ignore_for_file: must_be_immutable
class SoftthanksOneItemModel {
  SoftthanksOneItemModel({
    this.thewaythe,
    this.id,
  }) {
    thewaythe = thewaythe ?? "msg_the_way_the_sunlight".tr;
    id = id ?? "";
  }

  String? thewaythe;
  String? id;
}
