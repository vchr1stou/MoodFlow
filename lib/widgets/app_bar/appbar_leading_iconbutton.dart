import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class AppbarLeadingIconbutton extends StatelessWidget {
  final String imagePath;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const AppbarLeadingIconbutton({
    Key? key,
    required this.imagePath,
    this.margin,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomImageView(
          imagePath: imagePath,
          height: SizeUtils.height * 0.03,
          width: SizeUtils.width * 0.06,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
