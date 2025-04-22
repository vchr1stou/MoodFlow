import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/custom_drop_down.dart';
import '../models/listcooking_one_item_model.dart';

// ignore_for_file: must_be_immutable
class ListcookingOneItemWidget extends StatelessWidget {
  ListcookingOneItemWidget(this.listcookingOneItemModelObj, {Key? key})
      : super(
          key: key,
        );

  final ListcookingOneItemModel listcookingOneItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 10.h,
        vertical: 14.h,
      ),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                CustomImageView(
                  imagePath: listcookingOneItemModelObj.cookingOne!,
                  height: 20.h,
                  width: 32.h,
                  margin: EdgeInsets.only(bottom: 2.h),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    listcookingOneItemModelObj.cookingTwo!,
                    style: CustomTextStyles.labelLargeRobotoOnPrimaryBold13_1,
                  ),
                )
              ],
            ),
          ),
          Text(
            listcookingOneItemModelObj.description!,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.labelMediumRobotoOnPrimary,
          ),
          _buildSourcecooking(context),
          SizedBox(height: 4.h)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildSourcecooking(BuildContext context) {
    return CustomElevatedButton(
      height: 24.h,
      text: "msg_source_cooking".tr,
      buttonStyle: CustomButtonStyles.none,
      decoration: CustomButtonStyles.gradientPrimaryToPrimaryTL12Decoration,
      buttonTextStyle: CustomTextStyles.robotoOnPrimaryBold,
    );
  }
}
