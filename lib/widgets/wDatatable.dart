import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:ql_khach/utils/utils.dart';

class Wdatatable extends StatelessWidget {
  List<TitleColumn> columns;
  List<DataRow> rows;
  Wdatatable({super.key, required this.columns, required this.rows});

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      minWidth: 1150,
      columns: columns
          .map(
            (e) => DataColumn2(
                label: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(e.text),
                ),
                numeric: e.isNumber,
                fixedWidth: e.width),
          )
          .toList(),
      rows: rows,
      headingRowHeight: 25,
      dividerThickness: 0,
      fixedTopRows: 2,
      headingRowColor: WidgetStatePropertyAll(context.colorScheme.primary.withOpacity(.2)),
      border: TableBorder.all(color: Colors.black, width: .5),
      headingTextStyle: context.textTheme.titleSmall!
          .copyWith(fontSize: 12, color: Colors.blue.shade900),
      dataTextStyle: context.textTheme.bodySmall!.copyWith(fontSize: 12),
      dataRowHeight: 25,
      columnSpacing: 0,
      horizontalMargin: 0,
    );
  }
}

class TitleColumn {
  String text;
  bool isNumber;
  double? width;

  TitleColumn({required this.text, this.isNumber = false, this.width});
}
