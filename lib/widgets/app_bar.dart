import 'package:flutter/material.dart';
import 'package:moodflow/core/utils/size_utils.dart';

PreferredSizeWidget buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 40,
      leading: Align(
        alignment: Alignment.centerLeft,
        child: buildBackButton(context),
      ),
    );
  }

  Widget buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: EdgeInsets.only(left: 12.h),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            Positioned(
              child: Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }