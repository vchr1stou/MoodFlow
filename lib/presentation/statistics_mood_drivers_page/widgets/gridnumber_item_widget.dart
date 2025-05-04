import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
      children: [
        CustomImageView(
          imagePath: gridnumberItemModelObj.image,
          height: 24.h,
          width: 24.h,
        ),
        SizedBox(height: 4.h),
        Text(
          gridnumberItemModelObj.number?.tr() ?? "",
          style: theme.textTheme.titleSmall,
        ),
        SizedBox(height: 4.h),
        Text(
          gridnumberItemModelObj.exercise?.tr() ?? "",
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
