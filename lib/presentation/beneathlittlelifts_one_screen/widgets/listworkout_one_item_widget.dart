import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/custom_drop_down.dart';
import '../models/listworkout_one_item_model.dart';

// ignore_for_file: must_be_immutable
class ListworkoutOneItemWidget extends StatelessWidget {
  ListworkoutOneItemWidget(this.listworkoutOneItemModelObj, {Key? key})
      : super(
          key: key,
        );

  final ListworkoutOneItemModel listworkoutOneItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 10.h,
        vertical: 8.h,
      ),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        spacing: 2,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 4.h),
            child: Row(
              children: [
                CustomImageView(
                  imagePath: listworkoutOneItemModelObj.workoutOne!,
                  height: 24.h,
                  width: 24.h,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.h),
                    child: Text(
                      listworkoutOneItemModelObj.workoutTwo!,
                      style: CustomTextStyles.labelLargeRobotoOnPrimaryBold13_1,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Text(
              listworkoutOneItemModelObj.description!,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.labelMediumRobotoOnPrimary,
            ),
          ),
          CustomElevatedButton(
            height: 24.h,
            text: "msg_source_exercise".tr,
            buttonStyle: CustomButtonStyles.none,
            decoration:
                CustomButtonStyles.gradientPrimaryToPrimaryTL12Decoration,
            buttonTextStyle: CustomTextStyles.robotoOnPrimaryBold,
          ),
          SizedBox(height: 10.h)
        ],
      ),
    );
  }
}
