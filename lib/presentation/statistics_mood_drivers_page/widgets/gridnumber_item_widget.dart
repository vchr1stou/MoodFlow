import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/gridnumber_item_model.dart';

// ignore_for_file: must_be_immutable
class GridnumberItemWidget extends StatelessWidget {
  GridnumberItemWidget(
    this.gridnumberItemModelObj, {
    Key? key,
  }) : super(key: key);

  GridnumberItemModel gridnumberItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 2,
      children: [
        Container(
          width: double.maxFinite,
          decoration: AppDecoration.controlsIdle.copyWith(
            borderRadius: BorderRadiusStyle.circleBorder18,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.h),
                  decoration: AppDecoration.fillOnPrimary.copyWith(
                    borderRadius: BorderRadiusStyle.circleBorder8,
                  ),
                  child: Text(
                    gridnumberItemModelObj.number!,
                    textAlign: TextAlign.left,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
              CustomImageView(
                imagePath: gridnumberItemModelObj.image!,
                height: 22.h,
                width: 18.h,
                margin: EdgeInsets.only(left: 12.h),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
        Text(
          gridnumberItemModelObj.exercise!,
          style: theme.textTheme.labelMedium,
        ),
      ],
    );
  }
}
