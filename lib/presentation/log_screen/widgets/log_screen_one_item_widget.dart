import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/log_screen_one_item_model.dart';

// ignore_for_file: must_be_immutable
class LogScreenOneItemWidget extends StatelessWidget {
  LogScreenOneItemWidget(this.logScreenOneItemModelObj, {Key? key})
      : super(
          key: key,
        );

  LogScreenOneItemModel logScreenOneItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomImageView(
          imagePath: logScreenOneItemModelObj.workOne!,
          height: 42.h,
          width: 42.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.h),
          child: Text(
            logScreenOneItemModelObj.workTwo!,
            style: theme.textTheme.labelMedium,
          ),
        )
      ],
    );
  }
}
