import 'package:flutter/material.dart';


import '../utils/responsive.dart';


class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final String fontFamily;
  final TextDecoration textDecoration;
  final TextOverflow overflow;
  final TextAlign textAlign;


  const CustomText(
      this.text, {
        super.key,
        required this.fontSize,
        required this.color,
        required this.fontFamily,
        this.textDecoration = TextDecoration.none,
        this.overflow = TextOverflow.clip,
        this.textAlign = TextAlign.start,

      });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final adjustedFontSize = responsive.fontSize(fontSize);

    final adjustLineHeight = responsive.height(1.5);

    final textStyle = TextStyle(
      overflow: overflow,
      fontSize: adjustedFontSize,
      color: color,
      fontFamily: fontFamily,
      decoration: textDecoration,
      decorationColor: color,
      height: adjustLineHeight,
    );

    return Text(
      text,
      textAlign: textAlign,
      style: textStyle,
      overflow: overflow,
    );
  }
}