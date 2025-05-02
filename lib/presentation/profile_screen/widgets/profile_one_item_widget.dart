import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_switch.dart';
import '../models/profile_one_item_model.dart';

// ignore_for_file: must_be_immutable
class ProfileOneItemWidget extends StatelessWidget {
  ProfileOneItemWidget(
    this.profileOneItemModelObj, {
    Key? key,
    this.changeSwitchBox,
  }) : super(key: key);

  final ProfileOneItemModel profileOneItemModelObj;
  final Function(bool)? changeSwitchBox;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 14.h),
      decoration: AppDecoration.viewsRegular,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 92.h,
            margin: EdgeInsets.only(left: 10.h),
            child: Text(
              profileOneItemModelObj.title!,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium,
            ),
          ),
          const Spacer(),
          CustomSwitch(
            margin: EdgeInsets.only(left: 24.h),
            value: profileOneItemModelObj.isSelectedSwitch ?? false,
            onChange: (value) {
              changeSwitchBox?.call(value);
            },
          ),
        ],
      ),
    );
  }
}
