import 'package:flutter/material.dart';


extension BuiContextExtenson on BuildContext{
  ThemeData get _theme =>Theme.of(this);

  TextTheme get textTheme => _theme.textTheme;
  ColorScheme get colorScheme => _theme.colorScheme;
  Size get deviceSize => MediaQuery.sizeOf(this);

}

extension ChangeString on String{
  bool get toBool=> int.parse(this)==0 ? false : true;

  bool get isNumeric => num.tryParse(this) != null ? true : false;

  int get toInt => isNumeric ? int.parse(this) : 0;

  double get toDouble => isNumeric ? double.parse(this) : 0.0;

  String lastChars(int n) => substring(length - n);
}