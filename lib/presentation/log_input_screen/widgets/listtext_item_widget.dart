import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/listtext_item_model.dart';

// ignore_for_file: must_be_immutable
class ListtextItemWidget extends StatelessWidget {
  ListtextItemWidget(this.listtextItemModelObj, {Key? key})
      : super(
          key: key,
        );

  ListtextItemModel listtextItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.h),
      decoration: AppDecoration.outline1.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomImageView(
            imagePath: listtextItemModelObj.image!,
            height: 72.h,
            width: 74.h,
          ),
          SizedBox(
            width: 256.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listtextItemModelObj.text!,
                  style: CustomTextStyles.titleMediumOnPrimaryBold,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 2.h),
                  child: Text(
                    listtextItemModelObj.chatyourfeels!,
                    style: CustomTextStyles.labelMediumRoboto,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
