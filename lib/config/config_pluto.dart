import 'package:flutter/material.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

class ConfigPluto {
  ConfigPluto();

  static PlutoColumn column(
      {required String title,
      required String field,
      required PlutoColumnType type,
      double? width,
      bool readOnly = false,
      bool enableSorting = true,
      bool hide = false,
      Widget Function(PlutoColumnFooterRendererContext)? footerRenderer,
      Widget Function(PlutoColumnRendererContext)? renderer,
      PlutoColumnTextAlign textAlign = PlutoColumnTextAlign.start}) {
    return PlutoColumn(
        title: title,
        renderer: renderer,
        field: field,
        type: type,
        hide: hide,
        textAlign: textAlign,
        width: width ?? PlutoGridSettings.columnWidth,
        readOnly: true,
        enableColumnDrag: false,
        enableDropToResize: false,
        enableContextMenu: false,
        footerRenderer: footerRenderer,
        enableSorting: enableSorting,
        minWidth: 20);
  }

  static PlutoGridStyleConfig styleConfig() {
    return const PlutoGridStyleConfig(
      columnFilterHeight: 25,
      defaultColumnFilterPadding: EdgeInsets.zero,
      rowHeight: 25,
      columnHeight: 30,
      defaultColumnTitlePadding: EdgeInsets.only(left: 5, right: 5),
      defaultCellPadding: EdgeInsets.only(left: 5, right: 5),
      columnTextStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      cellTextStyle: TextStyle(fontSize: 12),
    );
  }

  static PlutoGridLocaleText localeText() {
    return const PlutoGridLocaleText(filterContains: '');
  }
}
