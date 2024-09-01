import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'custom_theme/elevated_button_theme.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  primaryColor: lightColorScheme.primary,
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  fontFamily: 'Manrope',
  elevatedButtonTheme: MyElevatedButtonTheme.lightElevatedButtonTheme,
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  primaryColor: darkColorScheme.primary,
  scaffoldBackgroundColor: const Color(0xFF000000),
  fontFamily: 'Manrope',
  elevatedButtonTheme: MyElevatedButtonTheme.darkElevatedButtonTheme,
);
