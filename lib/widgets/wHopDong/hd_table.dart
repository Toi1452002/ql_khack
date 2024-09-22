import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:ql_khach/config/config.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/providers/providers.dart';

class HdTable extends ConsumerWidget {
  HdTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hdTable = ref.read(hdTableProvider.notifier);

    return PlutoGrid(
      columns: _columns,
      rows: [],
      rowColorCallback: (e) {
        if(e.row.cells['Con']!.value <= 3 && e.row.cells['NgayHetHan']!.value!='' && e.row.cells['NgayTruyCap']!.value !=''){
          return Colors.red.shade50;
        }

        if(e.row.cells['DaKichHoat']!.value == 0){
          return Colors.yellow.shade50;

        }
        if (e.rowIdx % 2 == 0) {
          return Colors.white;
        }
        return Colors.grey.shade100;
      },
      onLoaded: (e) {
        e.stateManager.setShowLoading(true);
        e.stateManager.columnFooterHeight = 25;
        e.stateManager.addListener((){
          final row = e.stateManager.currentCell;
          if (row != null) {
            final maHD = row.row.cells['MaHD']!.value;
            ref.read(hdMaHD.notifier).state = maHD;
          }
        });
        hdTable.stateManager = e.stateManager;
      },
      noRowsWidget: Center(
        child: Text(
          'No data',
          style: context.textTheme.titleSmall,
        ),
      ),
      configuration: PlutoGridConfiguration(
        localeText: ConfigPluto.localeText(),
        style: ConfigPluto.styleConfig(),
      ),
    );
  }

  final List<PlutoColumn> _columns = [
    ConfigPluto.column(
        title: '',
        field: 'num',
        width: 30,
        type: const PlutoColumnTypeText(),
        enableSorting: false,
        textAlign: PlutoColumnTextAlign.center),
    ConfigPluto.column(
        title: 'MaHD',
        field: 'MaHD',
        width: 50,
        type: const PlutoColumnTypeText(),
        textAlign: PlutoColumnTextAlign.center),
    ConfigPluto.column(
        title: 'MaSP', field: 'MaSP', width: 70, type: const PlutoColumnTypeText()),
    ConfigPluto.column(
        title: 'MaSPCT',
        field: 'MaSPCT',
        width: 80,
        type: const PlutoColumnTypeText()),
    ConfigPluto.column(
        title: 'Tên gọi',
        field: 'TenGoi',
        width: 100,
        type: const PlutoColumnTypeText()),
    ConfigPluto.column(
        title: 'Tên mở rộng', field: 'TenMoRong', type: const PlutoColumnTypeText()),
    ConfigPluto.column(
        title: 'Tên Cty',
        field: 'TenCty',
        width: 100,
        type: const PlutoColumnTypeText()),
    ConfigPluto.column(
        title: 'Mã kích hoạt', field: 'MaKichHoat',width: 160, type: const PlutoColumnTypeText()),
    ConfigPluto.column(
        title: 'Thời hạn',
        field: 'ThoiHan',
        width: 100,
        type: const PlutoColumnTypeText(),),
    ConfigPluto.column(
        title: 'Ngày hết hạn',
        field: 'NgayHetHan',
        type: PlutoColumnType.date(format: 'dd/MM/yyyy',popupIcon: null),
        width: 100),
    ConfigPluto.column(
        title: 'Ngày truy cập',
        field: 'NgayTruyCap',
        type: PlutoColumnType.date(format: 'dd/MM/yyyy',popupIcon: null),
        width: 100),
    ConfigPluto.column(
        title: 'Phí',
        field: 'Phi',
        width: 80,
        textAlign: PlutoColumnTextAlign.right,
        type: PlutoColumnType.number(),
        footerRenderer: (e) {
          return PlutoAggregateColumnFooter(
              alignment: Alignment.centerRight,
              rendererContext: e,
              type: PlutoAggregateColumnType.sum);
        }),
    ConfigPluto.column(
        title: 'Thực thu',
        field: 'ThucThu',
        width: 80,
        textAlign: PlutoColumnTextAlign.right,
        type: PlutoColumnType.number(),
        footerRenderer: (e) {
          return PlutoAggregateColumnFooter(
              alignment: Alignment.centerRight,
              rendererContext: e,
              type: PlutoAggregateColumnType.sum);
        }),
    ConfigPluto.column(title: 'SNCL', field: 'Con',width: 50,textAlign: PlutoColumnTextAlign.center, type: PlutoColumnType.number()),
    ConfigPluto.column(title: 'DaKichHoat', field: 'DaKichHoat', type: PlutoColumnType.text(),hide: true),
  ];
}
