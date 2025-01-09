import 'package:flutter/material.dart';

//DEFINE COLORS
final primaryPurple = Color(0xFF6B46C1);
final lightPurple = Color(0xFF9F7AEA);
final darkPurple = Color(0xFF553C9A);

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryPurple,
      secondary: lightPurple,
      tertiary: darkPurple,
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: primaryPurple.withOpacity(0.15),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return TextStyle(
            color: primaryPurple,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          );
        }
        return TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        );
      }),
    ),
  );
}
