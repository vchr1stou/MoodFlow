import 'package:flutter/material.dart';
import '../../core/app_export.dart';

enum Style { bgShadowBlack900 }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    this.height,
    this.shape,
    this.styleType,
    this.leadingWidth,
    this.leading,
    this.title,
    this.centerTitle,
    this.actions,
  }) : super(key: key);

  final double? height;
  final ShapeBorder? shape;
  final Style? styleType;
  final double? leadingWidth;
  final Widget? leading;
  final Widget? title;
  final bool? centerTitle;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      shape: shape,
      toolbarHeight: height ?? 56.h,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: _getStyle(),
      leadingWidth: leadingWidth ?? 0,
      leading: leading,
      title: title,
      titleSpacing: 0,
      centerTitle: centerTitle ?? false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size(
        SizeUtils.width,
        height ?? 56.h,
      );

  Widget? _getStyle() {
    switch (styleType) {
      case Style.bgShadowBlack900:
        return Container(
          height: 12.h,
          width: 268.h,
          margin: EdgeInsets.only(
            left: 51.h,
            top: 8.h,
            bottom: 10.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.h),
            boxShadow: [
              BoxShadow(
                color: appTheme.black900.withValues(alpha: 0.1),
              ),
              BoxShadow(
                color: appTheme.blueGray1007f,
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(1, 1.5),
              ),
            ],
          ),
        );
      default:
        return null;
    }
  }
}
