import 'package:flutter/material.dart';
import 'package:knue_smart_content/common/const/color_schemes.g.dart';

const mainColor = Color(0x8a000000);
const redColor = Color(0xFFE57373);
const greenColor = Color(0xFFAED582);
const purpleColor = Color(0xffce93d8);
const blueColor = Color(0xff90caf9);
const yellowColor = Color(0xFFFFE59D);
const deepGreenColor = Color(0xff2e7d32);

ThemeData mainTheme(bool isLight) {
  const inputBorder = UnderlineInputBorder(
    borderSide: BorderSide(),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'noto_serif',
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: pastelBlack,
      ),
      titleMedium: TextStyle(
        fontFamily: 'noto_serif',
        fontSize: 30,
        fontWeight: FontWeight.w800,
      ),
      bodyLarge: TextStyle(
        // fontFamily: 'noto_sans',
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      bodyMedium: TextStyle(
        // fontFamily: 'noto_sans',
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      bodySmall: TextStyle(
        // fontFamily: 'noto_sans',
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
    fontFamily: 'noto_sans',
    dividerColor: Colors.transparent,

    // Floating button theme
    // floatingActionButtonTheme: const FloatingActionButtonThemeData(
    //   backgroundColor: deepGreenColor,
    //   sizeConstraints: BoxConstraints.tightFor(width: 40, height: 40),
    // ),

    //elevate button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        side: const BorderSide(color: pastelGray, width: 0.9),
        shadowColor: pastelBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // input decoration
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      border: inputBorder,
      enabledBorder: inputBorder,
      focusedBorder: inputBorder,
      errorBorder: inputBorder.copyWith(
        borderSide: BorderSide(color: Colors.red.withOpacity(0.8), width: 1),
      ),
      focusedErrorBorder: inputBorder,
    ),

    // primary color
    primaryColor: mainColor,
  );
}
