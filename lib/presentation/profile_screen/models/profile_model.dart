import '../../../core/app_export.dart';
import 'profile_one_item_model.dart';

// ignore_for_file: must_be_immutable
class ProfileModel {
  List<ProfileOneItemModel> profileOneItemList = [
    ProfileOneItemModel(
      dailyStreak: ImageConstant.imgFlamefill2,
      title: "lbl_daily_streak".tr,
    ),
    ProfileOneItemModel(
      dailyStreak: ImageConstant.imgMusicNote2,
      title: "lbl_music".tr,
    ),
    ProfileOneItemModel(
      dailyStreak: ImageConstant.imgAppleHapticsAndMusicNote,
      title: "lbl_haptic_feedback".tr,
    ),
    ProfileOneItemModel(), // Possibly placeholder or empty item
  ];
}
