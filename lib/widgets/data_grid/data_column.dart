import 'package:flutter/material.dart';
import 'package:trina_grid/trina_grid.dart';

enum ColumnType { text, num, date }

enum ColumnAlign { left, center, right }

enum TypeRender { numIndex, delete }

enum TypeFooter { sum, count }

class DataGridColumn {
  final List<String> title;
  final ColumnType columnType;
  final ColumnAlign columnAlign;
  final double width;
  final bool isEdit;
  final TypeRender? render;
  final void Function(dynamic value, TrinaColumnRendererContext? event)? onTapDelete;
  final Widget Function(TrinaColumnRendererContext)? renderer;
  final double? padding;
  final Color? headerColor;
  final bool showFooter;
  final bool frozen;
  final TextStyle? textStyle;
  final bool hide;
  final TypeFooter typeFooter;
  final bool readOnly;
  final bool enableFilter;
  const DataGridColumn({
    required this.title,
    this.columnType = ColumnType.text,
    this.width = 200,
    this.columnAlign = ColumnAlign.left,
    this.isEdit = false,
    this.render,
    this.onTapDelete,
    this.renderer,
    this.padding,
    this.headerColor,
    this.showFooter = false,
    this.frozen = false,
    this.textStyle,
    this.hide = false,
    this.readOnly = false,
    this.typeFooter = TypeFooter.sum, this.enableFilter = true
  });
}

class ColumnTextStyle {
  ColumnTextStyle._();

  static TextStyle red() => TextStyle(color: Colors.red.shade700, fontSize: 12, fontWeight: FontWeight.w500);

  static TextStyle redBlack() => TextStyle(color: Colors.red.shade900, fontSize: 12, fontWeight: FontWeight.w500);

  static TextStyle blue({FontWeight? fontWeight}) => TextStyle(
        color: Colors.blue.shade900,
        fontSize: 12,
        fontWeight: fontWeight ?? FontWeight.w500,
      );
}
