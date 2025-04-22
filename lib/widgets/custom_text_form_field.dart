import 'package:flutter/material.dart';
import '../core/app_export.dart';

extension TextFormFieldStyleHelper on CustomTextFormField {
  static CustomOutlineInputBorder get gradientBlackToGray =>
      CustomOutlineInputBorder(
        fillGradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 0),
          colors: [
            appTheme.black900.withValues(alpha: 0.1),
            appTheme.gray70019,
          ],
        ),
      );
}

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    Key? key,
    this.alignment,
    this.width,
    this.boxDecoration,
    this.scrollPadding,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.textStyle,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
  }) : super(key: key);

  final Alignment? alignment;
  final double? width;
  final BoxDecoration? boxDecoration;
  final TextEditingController? scrollPadding;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? autofocus;
  final TextStyle? textStyle;
  final bool? obscureText;
  final bool? readOnly;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final int? maxLines;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final EdgeInsets? contentPadding;
  final InputBorder? borderDecoration;
  final Color? fillColor;
  final bool? filled;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: textFormFieldWidget(context),
          )
        : textFormFieldWidget(context);
  }

  Widget textFormFieldWidget(BuildContext context) => Container(
        width: width ?? double.maxFinite,
        decoration: boxDecoration,
        child: TextFormField(
          scrollPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          controller: controller,
          focusNode: focusNode,
          onTapOutside: (event) {
            if (focusNode != null) {
              focusNode?.unfocus();
            } else {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          autofocus: autofocus!,
          style: textStyle ?? CustomTextStyles.titleMediumSFProGray700,
          obscureText: obscureText!,
          readOnly: readOnly!,
          onTap: () => onTap?.call(),
          textInputAction: textInputAction,
          keyboardType: textInputType,
          maxLines: maxLines ?? 1,
          decoration: decoration,
          validator: validator,
        ),
      );

  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle ?? CustomTextStyles.titleMediumSFProGray700,
        prefixIcon: prefix,
        prefixIconConstraints: prefixConstraints,
        suffixIcon: suffix,
        suffixIconConstraints: suffixConstraints,
        isDense: true,
        contentPadding: contentPadding ?? EdgeInsets.symmetric(vertical: 10.h),
        fillColor: fillColor ?? appTheme.blueGray1007f,
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(22.h),
              borderSide: BorderSide(
                color: appTheme.black900.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(22.h),
              borderSide: BorderSide(
                color: appTheme.black900.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
        focusedBorder: (borderDecoration ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.h),
                ))
            .copyWith(
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1,
          ),
        ),
      );
}

// ignore_for_file: must_be_immutable
class CustomOutlineInputBorder extends OutlineInputBorder {
  CustomOutlineInputBorder({
    this.borderGradient,
    this.fillGradient,
    this.solidFillColor,
    this.solidBorderColor,
    BorderRadius borderRadius = BorderRadius.zero,
    BorderSide borderSide = BorderSide.none,
  }) : super(
          borderRadius: borderRadius,
          borderSide: borderSide,
        );

  final Gradient? borderGradient;
  final Gradient? fillGradient;
  final Color? solidFillColor;
  final Color? solidBorderColor;

  Paint? _cachedFillPaint;
  Paint? _cachedBorderPaint;
  Rect? _cachedRect;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0,
    double gapPercentage = 0,
    TextDirection? textDirection,
  }) {
    if (_cachedRect != rect) {
      _cachedRect = rect;
      final double borderWidth = borderSide.width;
      _cachedBorderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth;

      if (solidBorderColor != null) {
        _cachedBorderPaint!.color = solidBorderColor!;
      } else {
        _cachedBorderPaint!.shader = borderGradient?.createShader(rect);
      }

      final Rect innerRect = rect.deflate(borderWidth / 2);
      _cachedFillPaint = Paint()..style = PaintingStyle.fill;

      if (solidFillColor != null) {
        _cachedFillPaint!.color = solidFillColor!;
      } else if (fillGradient != null) {
        _cachedFillPaint!.shader = fillGradient!.createShader(innerRect);
      }
    }

    final RRect outerRRect = borderRadius.toRRect(rect);
    final double borderWidth = borderSide.width;

    canvas.drawRRect(outerRRect.deflate(borderWidth / 2), _cachedFillPaint!);
    canvas.drawRRect(outerRRect.deflate(borderWidth / 2), _cachedBorderPaint!);
  }
}
