import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/custom_drop_down.dart';
import '../models/listmovie_time_item_model.dart';
import 'package:easy_localization/easy_localization.dart';

// ignore_for_file: must_be_immutable
class ListmovieTimeItemWidget extends StatelessWidget {
  ListmovieTimeItemWidget(this.listmovieTimeItemModelObj, {Key? key})
      : super(
          key: key,
        );

  final ListmovieTimeItemModel listmovieTimeItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 10.h,
        vertical: 12.h,
      ),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 2.h),
            child: Row(
              children: [
                CustomImageView(
                  imagePath: listmovieTimeItemModelObj.movieTimeOne!,
                  height: 26.h,
                  width: 20.h,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.h),
                    child: Text(
                      listmovieTimeItemModelObj.movietime!,
                      style: CustomTextStyles.labelLargeRobotoOnPrimaryBold13_1,
                    ),
                  ),
                )
              ],
            ),
          ),
          Text(
            listmovieTimeItemModelObj.description!,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.labelMediumRobotoOnPrimary,
          ),
          _buildSourcehow(context),
          SizedBox(height: 6.h)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildSourcehow(BuildContext context) {
    return CustomElevatedButton(
      height: 24.h,
      text: "msg_source_how_watching".tr(),
      buttonStyle: CustomButtonStyles.none,
      decoration: CustomButtonStyles.gradientPrimaryToPrimaryTL12Decoration,
      buttonTextStyle: CustomTextStyles.robotoOnPrimaryBold,
    );
  }
}
