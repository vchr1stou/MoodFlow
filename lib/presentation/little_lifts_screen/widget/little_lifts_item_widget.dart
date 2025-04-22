import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/little_lifts_item_model.dart';

// ignore_for_file: must_be_immutable
class LittleLiftsItemWidget extends StatelessWidget {
  LittleLiftsItemWidget(this.littleLiftsItemModelObj, {Key? key})
      : super(
          key: key,
        );

  LittleLiftsItemModel littleLiftsItemModelObj;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 100,
          sigmaY: 100,
        ),
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(
            left: 24.h,
            top: 16.h,
            bottom: 16.h,
          ),
          decoration: AppDecoration.windowsGlassBlur.copyWith(
            borderRadius: BorderRadiusStyle.circleBorder18,
          ),
          child: Column(
            spacing: 2,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomImageView(
                imagePath: littleLiftsItemModelObj.workoutOne!,
                height: 44.h,
                width: 42.h,
              ),
              Text(
                littleLiftsItemModelObj.workoutTwo!,
                style: CustomTextStyles.labelLargeRobotoOnPrimaryBold,
              )
            ],
          ),
        ),
      ),
    );
  }
}
