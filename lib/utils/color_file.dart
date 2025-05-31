import 'package:flutter/material.dart';

class ColorFile {
  static const primaryColor = Color(0xFF2196F3);

  static const blackColor = Color(0xFF000000);
  static const whiteColor = Color(0xFFFFFFFF);
  static const offWhiteColor = Color(0x99FFFFFF);
  static const greenColor = Color(0xFF4CAF50);
  static const chipBackgroundBlue = Color(0x558AD3D5);
  static const lightBlueColor = Color(0xffF4F4F5);
  static const transparentColor = Color(0x00000000);
  static const redColor = Color(0xFFF44336);
  static const greyColor = Color(0xFF9E9E9E);
  static const lightGreyColor = Color(0xffF7F7F7);
  static const black12Material = Color(0x1F000000);
  static const black26Material = Color(0x42000000);
  static const lightGrayMaterial = Color(0xFFE0E0E0);
  static const black45Material = Color(0x73000000);

  static const vibrantOrangeGradient = LinearGradient(
    colors: [Color.fromARGB(255, 255, 136, 34), Color.fromARGB(255, 255, 177, 41)],
  );
  static const chatBackgroundGradient = LinearGradient(colors: [Color(0xFFe3edff), Color(0xFFcad8fd)]);
}

class ChatTheme {
  static ThemeData localUserTheme(BuildContext context) {
    final base = Theme.of(context);
    return base.copyWith(
      textTheme: base.textTheme.apply(bodyColor: ColorFile.whiteColor, displayColor: ColorFile.offWhiteColor),
      cardTheme: base.cardTheme.copyWith(color: ColorFile.primaryColor),
    );
  }

  static ThemeData remoteUserTheme(BuildContext context) {
    return Theme.of(context); // Just reuse existing theme
  }

  static const BoxDecoration appBarGradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [

        Color.fromARGB(255, 176, 106, 231),
        Color.fromARGB(255, 166, 112, 232),
        Color.fromARGB(255, 131, 123, 232),
        Color.fromARGB(255, 104, 132, 231),
      ],
      transform: GradientRotation(40.0 * (3.141592653589793 / 180.0)),

    ),
  );

  static const BoxDecoration chatBackgroundDecoration = BoxDecoration(gradient: ColorFile.chatBackgroundGradient);
}
