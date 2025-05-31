
import 'package:flutter/material.dart';

import '../utils/color_file.dart';

import '../utils/constant_file.dart';
import '../utils/responsive.dart';
import 'custom_text.dart';

enum ButtonStyleType { outlined, elevated, text, gradient }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final ButtonStyleType style;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color textColor;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final LinearGradient? gradient;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.style = ButtonStyleType.gradient,
    this.backgroundColor,
    this.borderColor,
    this.textColor = ColorFile.whiteColor,
    this.elevation = 0,
    this.borderRadius,
    this.gradient = ColorFile.vibrantOrangeGradient,
    this.padding,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, res) {
        final double buttonWidth = width != null ? res.width(width!) : res.size.width;
        final BorderRadius effectiveRadius = borderRadius ?? BorderRadius.circular(res.radius(80));

        Color? background;
        Gradient? bgGradient;

        switch (style) {
          case ButtonStyleType.gradient:
            bgGradient = gradient;
            background = null;
            break;
          case ButtonStyleType.elevated:
            background = backgroundColor ?? ColorFile.primaryColor;
            break;
          case ButtonStyleType.outlined:
            background = Colors.transparent;
            break;
          case ButtonStyleType.text:
            background = Colors.transparent;
            break;
        }

        return Material(
          elevation: style == ButtonStyleType.elevated ? res.radius(elevation) : 0,
          borderRadius: effectiveRadius,
          child: InkWell(
            borderRadius: effectiveRadius,
            onTap: isLoading ? null : onPressed,
            child: Container(
              width: buttonWidth,
              height: res.height(50),
              padding: padding ?? EdgeInsets.symmetric(horizontal: res.width(20), vertical: res.height(12)),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: background,
                gradient: bgGradient,
                borderRadius: effectiveRadius,
                border: style == ButtonStyleType.outlined
                    ? Border.all(color: borderColor ?? ColorFile.primaryColor)
                    : null,
              ),
              child: isLoading
                  ? SizedBox(
                height: res.height(24),
                width: res.width(24),
                child: CircularProgressIndicator(
                  strokeWidth: res.width(2.5),
                  valueColor: AlwaysStoppedAnimation<Color>(ColorFile.whiteColor),
                ),
              )
                  : CustomText(
                text,
                fontSize: res.fontSize(ConstantsFile.regularFontSize),
                color: textColor,
                fontFamily: ConstantsFile.boldFont,
              ),
            ),
          ),
        );
      },
    );
  }
}

