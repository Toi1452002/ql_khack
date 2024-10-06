
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:ql_khach/config/config.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/extension.dart';

class KhachTable extends ConsumerWidget {
  KhachTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableState = ref.read(dsKhachTableProvider.notifier);
    return PlutoGrid(
      columns: _column,
      rows: [],
      rowColorCallback: (e) {
        if (e.rowIdx % 2 == 0) {
          return Colors.white;
        }
        return Colors.grey.shade100;
      },
      onLoaded: (e) {
        e.stateManager.columnFooterHeight = 25;
        e.stateManager.setShowLoading(true);
        e.stateManager.addListener(() {
          final row = e.stateManager.currentCell;
          if (row != null) {
            final maKH = row.row.cells['MaKH']!.value;
            ref.read(maKhachSelectProvider.notifier).state = maKH;
          }
        });
        tableState.stateManager = e.stateManager;
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

  final List<PlutoColumn> _column = [
    ConfigPluto.column(
        title: '',
        field: 'num',
        textAlign: PlutoColumnTextAlign.center,
        enableSorting: false,
        type: PlutoColumnType.text(),
        footerRenderer: (e) {
          return PlutoAggregateColumnFooter(
              padding: const EdgeInsets.only(right: 5),
              alignment: Alignment.centerRight,
              rendererContext: e,
              type: PlutoAggregateColumnType.count);
        },
        width: 40),
    ConfigPluto.column(
        title: 'MaKH',
        field: 'MaKH',
        textAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.text(),
        width: 50),
    // ConfigPluto.column(
    //     title: 'MaSP', field: 'MaSP', type: PlutoColumnType.text(), width: 70),
    ConfigPluto.column(
        title: 'Tên gọi',
        field: 'TenGoi',
        type: PlutoColumnType.text(),
        width: 100),
    ConfigPluto.column(
        title: 'Tên mở rộng', field: 'TenMoRong', type: PlutoColumnType.text()),
    ConfigPluto.column(
        title: 'Địa chỉ', field: 'DiaChi', type: PlutoColumnType.text()),
    ConfigPluto.column(
        title: 'Khu vực',
        field: 'KhuVuc',
        type: PlutoColumnType.text(),
        width: 100),
    ConfigPluto.column(
        title: 'Điện thoại',
        field: 'DienThoai',
        type: PlutoColumnType.text(),
        width: 100),
    ConfigPluto.column(
        title: 'Số tiền',
        field: 'SoTien',
        type: PlutoColumnType.number(),
        textAlign: PlutoColumnTextAlign.end,
        footerRenderer: (e) {
          return PlutoAggregateColumnFooter(
              alignment: Alignment.centerRight,
              rendererContext: e,
              type: PlutoAggregateColumnType.sum);
        },
        width: 80),
    ConfigPluto.column(
        title: 'Nguồn liên hệ',
        field: 'NguonLienHe',
        type: PlutoColumnType.text(),
        width: 100),
    ConfigPluto.column(
        title: 'Tên Cty',
        field: 'TenCty',
        type: PlutoColumnType.text(),
        width: 100),
    ConfigPluto.column(
        title: 'Ghi chú', field: 'GhiChu', type: PlutoColumnType.text()),
  ];
}
