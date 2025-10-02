import 'package:flutter/services.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:string_validator/string_validator.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../../utils/helper.dart';
import 'button_filter.dart';
import 'data_column.dart';
import 'package:flutter/material.dart' as mt;

export 'data_column.dart';

class DataGrid extends StatefulWidget {
  final List<DataGridColumn> columns;
  final void Function(TrinaGridOnLoadedEvent)? onLoaded;
  final bool hideFilter;
  final void Function(TrinaGridOnRowDoubleTapEvent)? onRowDoubleTap;
  final void Function(TrinaGridOnChangedEvent)? onChange;
  final Color Function(TrinaRowColorContext)? rowColorCallback;
  final TrinaGridMode mode;
  final List<TrinaColumnGroup>? columnGroups;
  final double? columnHeight;
  final Color? cellReadonlyColor;

  const DataGrid(
      {super.key,
      required this.columns,
      this.onLoaded,
      this.hideFilter = true,
      this.onRowDoubleTap,
      this.onChange,
      this.rowColorCallback,
      this.mode = TrinaGridMode.normal,
      this.columnGroups,
      this.columnHeight,
      this.cellReadonlyColor});

  @override
  State<DataGrid> createState() => _DataGridState();
}

class _DataGridState extends State<DataGrid> {
  Map<String, List<dynamic>> filters = {};

  void onSetFilterNull(TrinaGridStateManager state) {
    if (state.rows.isNotEmpty) {
      Map<String, dynamic> a = state.rows.first.toJson();
      for (var x in a.keys) {
        if (!['null', 'dl'].contains(x)) {
          filters.addEntries({x.toString(): []}.entries);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TrinaGrid(
      mode: widget.mode,
      onLoaded: widget.onLoaded,
      onRowDoubleTap: widget.onRowDoubleTap,
      onChanged: widget.onChange,
      rowColorCallback: widget.rowColorCallback,
      columns: widget.columns.map((e) {
        TrinaColumnType type = TrinaColumnType.text();
        TrinaColumnTextAlign textAlign = TrinaColumnTextAlign.start;
        Widget Function(TrinaColumnRendererContext)? renderer = e.renderer;
        EdgeInsets? cellPadding = e.padding == null ? null : EdgeInsets.all(e.padding!);
        Widget Function(TrinaColumnTitleRendererContext)? titleRenderer;
        if (e.columnType == ColumnType.num) type = TrinaColumnType.number(format: '#,###.#');
        if (e.columnType == ColumnType.date) type = TrinaColumnType.date(format: 'dd/MM/yyyy', popupIcon: null);

        if (e.columnAlign == ColumnAlign.right || e.columnType == ColumnType.num) {
          textAlign = TrinaColumnTextAlign.right;
        }
        if (e.columnAlign == ColumnAlign.center) textAlign = TrinaColumnTextAlign.center;
        if (e.render == TypeRender.numIndex) {
          renderer = (re) => Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.gray.shade300.withValues(alpha: .7),
                  border: Border(right: BorderSide(width: .5)),
                ),
                child: Text("${re.rowIdx + 1}", style: TextStyle(fontSize: 13)).medium,
              );
          cellPadding = EdgeInsets.zero;
          titleRenderer = (re) => Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  border: Border(right: BorderSide(width: .5)),
                ),
              );
        }

        if (e.render == TypeRender.delete) {
          renderer = (re) => mt.InkWell(
                onTap: () {
                  if (re.cell.value != '') {
                    e.onTapDelete?.call(re.cell.value, re);
                  }

                  re.stateManager.setKeepFocus(true);
                  re.stateManager.setCurrentCell(re.cell, re.rowIdx);
                },
                child: Icon(mt.Icons.delete, color: Colors.red.shade400),
              );
          titleRenderer = (re) => Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  border: Border(right: BorderSide(width: .5)),
                ),
              );
          cellPadding = EdgeInsets.zero;
        }
        if (e.textStyle != null) {
          renderer = (re) => Text(
                softWrap: false,
                e.columnType == ColumnType.text ? re.cell.value : Helper.formatNum(re.cell.value),
                textAlign: e.columnAlign == ColumnAlign.center
                    ? TextAlign.center
                    : (e.columnType == ColumnType.text ? TextAlign.left : TextAlign.end),
                style: e.textStyle,
              );
        }
        if (e.render != TypeRender.delete && e.render != TypeRender.numIndex && e.title.first!='') {
          titleRenderer = (re) {
            final List<TrinaRow> filteredRows =
                re.stateManager.filterRows.isNotEmpty ? re.stateManager.filterRows : re.stateManager.rows;
            List<dynamic> availableValues =
                _getUniqueValues(re.column.field, filteredRows, str: e.columnType == ColumnType.text);
            Map<String, bool> map = {
              for (var value in availableValues)
                value.toString(): filters.isEmpty ? false : filters[re.column.field]!.contains(value),
            };

            if (widget.hideFilter) {
              onSetFilterNull(re.stateManager);
              re.stateManager.setFilter((re) => true);
            }

            if (!widget.hideFilter && filters.isEmpty) {
              onSetFilterNull(re.stateManager);
            }
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: filters.isEmpty
                    ? e.headerColor ?? Colors.blue.shade200
                    : (filters[re.column.field]!.isEmpty
                        ? e.headerColor ?? Colors.blue.shade200
                        : Colors.green.shade200),
                border: Border(right: BorderSide(width: .5)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(re.column.title, textAlign: TextAlign.center).medium,
                  if (!widget.hideFilter) Spacer(),
                  if (!widget.hideFilter)
                    ButtonFilter(
                      items: map,
                      field: re.column.field,
                      str: e.columnType == ColumnType.text,
                      onChanged: (val) {
                        filters[re.column.field] = val.entries
                            .where((e) => e.value)
                            .map((e) => availableValues.firstWhere((v) => v.toString() == e.key))
                            .toList();
                        re.stateManager.setFilter((row) {
                          final nameFilter = filters.keys.toList();

                          final List<bool> result = nameFilter.map((n) {
                            var x = row.cells[n]!.value;
                            if (isNumeric(x.toString()) && e.columnType != ColumnType.text) {
                              x = double.parse(x.toString()).toString();
                            }
                            return filters[n]!.isEmpty || filters[n]!.contains(x);
                          }).toList();
                          return result.every((e) => e);
                        });
                        setState(() {});
                      },
                    ),
                ],
              ),
            );
          };
        }

        return TrinaColumn(
          frozen: e.frozen ? TrinaColumnFrozen.start : TrinaColumnFrozen.none,
          renderer: renderer,
          title: e.title.first,
          field: e.title.last,
          type: type,
          width: e.width,
          readOnly: e.readOnly,
          hide: e.hide,
          footerRenderer: !e.showFooter
              ? null
              : (rendererContext) {
                  return TrinaAggregateColumnFooter(
                    rendererContext: rendererContext,
                    type:
                        e.typeFooter == TypeFooter.sum ? TrinaAggregateColumnType.sum : TrinaAggregateColumnType.count,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    titleSpanBuilder: (text) {
                      return [TextSpan(text: text, style: e.textStyle)];
                    },
                  );
                },
          enableColumnDrag: false,
          enableContextMenu: false,
          enableDropToResize: false,
          enableFilterMenuItem: e.enableFilter,
          enableSorting: false,
          enableAutoEditing: true,
          backgroundColor: e.headerColor,
          textAlign: textAlign,
          enableEditingMode: e.isEdit,
          cellPadding: cellPadding,
          titleRenderer: titleRenderer,
        );
      }).toList(),
      rows: [],

      columnGroups: widget.columnGroups,
      configuration: TrinaGridConfiguration(
        tabKeyAction: TrinaGridTabKeyAction.moveToNextOnEdge,
        enterKeyAction: TrinaGridEnterKeyAction.editingAndMoveRight,
        scrollbar: TrinaGridScrollbarConfig(showHorizontal: true, thickness: 5, isAlwaysShown: true),
        columnSize: const TrinaGridColumnSizeConfig(autoSizeMode: TrinaAutoSizeMode.none),
        shortcut: TrinaGridShortcut(
          actions: {
            ...TrinaGridShortcut.defaultActions,
            LogicalKeySet(LogicalKeyboardKey.escape): CustomEscKeyAction(),
            // LogicalKeySet(LogicalKeyboardKey.keyN,LogicalKeyboardKey.control): CustomEnterKeyAction(),
          },
        ),
        localeText: TrinaGridLocaleText(
          filterContains: ''
        ),
        style: TrinaGridStyleConfig(
          columnFilterHeight: 25,

          cellReadonlyColor: widget.cellReadonlyColor,
          defaultColumnFilterPadding: EdgeInsets.all(.2),
          borderColor: context.theme.colorScheme.mutedForeground,
          gridBorderRadius: BorderRadius.circular(2),
          activatedBorderColor: context.theme.colorScheme.primary,
          columnHeight: widget.columnHeight ?? 25,
          activatedColor: context.theme.colorScheme.primary.withValues(alpha: .1),
          rowHeight: 25,
          columnTextStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          rowColor: context.theme.colorScheme.popover,
          cellTextStyle: TextStyle(fontSize: 12, color: context.theme.colorScheme.foreground),
          defaultCellPadding: const EdgeInsets.only(left: 3, right: 4),
        ),
      ),
    );
  }

  // Lấy giá trị duy nhất từ cột dựa trên dữ liệu đã lọc
  List<dynamic> _getUniqueValues(String field, List<TrinaRow> currentRows, {bool str = false}) {
    final data = currentRows.map((row) => row.cells[field]?.value.toString()).toSet().toList();
    if (data.every((e) => e!=null && isNumeric(e)) && !str) {
      List<double> x = data.map((e) => double.parse(e!)).toList();
      x.sort();
      return x.map((e) {
        if (isInt(e.toString())) {
          return e.toInt().toString();
        } else {
          return e.toString();
        }
      }).toList();
    }

    if (data.every((e) => e!=null && e.contains('/') && e.length == 10)) {
      List<DateTime?> x = data.map((e) => Helper.strToDate(e!)).toList();
      x.sort();
      return x.map((e) {
        return Helper.dMy(e);
      }).toList();
    }
    data.sort();
    return data;
  }
}

class CustomEscKeyAction extends TrinaGridShortcutAction {
  @override
  void execute({required TrinaKeyManagerEvent keyEvent, required TrinaGridStateManager stateManager}) {
    stateManager.clearCurrentSelecting();
    stateManager.clearCurrentCell();
    stateManager.setKeepFocus(false);
  }
}
