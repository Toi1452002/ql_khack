import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeDataProvider = Provider<ThemeData>((ref) {
  ButtonStyle buttonStyle({Color? color}) => ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(color),
      shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))));
  return ThemeData(
    scrollbarTheme: ScrollbarThemeData(
      thickness: WidgetStatePropertyAll(3)
    ),
      appBarTheme: const AppBarTheme(
          toolbarHeight: 25, shadowColor: Colors.black, elevation: 2),
      drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
      scaffoldBackgroundColor: Colors.white,
      colorSchemeSeed: Colors.blue,

      textButtonTheme: TextButtonThemeData(style: buttonStyle()),
      filledButtonTheme: FilledButtonThemeData(style: buttonStyle()),
      outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle()),
      dialogTheme: DialogTheme(
          insetPadding: const EdgeInsets.symmetric(horizontal: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))),
      datePickerTheme: DatePickerThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))),
      cardTheme: CardTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          color: Colors.white),
      elevatedButtonTheme:
          ElevatedButtonThemeData(style: buttonStyle(color: Colors.white)));
});
