import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class AppbarTitleImage extends StatelessWidget {
  AppbarTitleImage({
    Key? key,
    this.imagePath,
    this.height,
    this.width,
    this.onTap,
    this.margin,
  }) : super(key: key);

  final double? height;
  final double? width;
  final String? imagePath;
  final Function? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          onTap?.call();
        },
        child: CustomImageView(
          imagePath: imagePath!,
          height: height ?? 22.h,
          width: width ?? 12.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
