
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:ql_khach/config/config.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/widgets/wDropdown/wdropdown.dart';

import '../../data/data.dart';



class HdTable extends ConsumerWidget {
  HdTable({super.key});

  void _onFilter(List<Hopdong> lst, String TH, bool DN,HdTableNotifier hdTable){
    hdTable.filter(lst,thang: TH,DN: DN);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hdTable = ref.read(hdTableProvider.notifier);
    final wLstHD = ref.watch(lstHopDongViewPVD);
    final wFilterTH = ref.watch(hdFilterTH);
    final wFilterDN = ref.watch(hdFilterDN);
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Spacer(),
               Row(
                 children: [
                   Wdropdown(
                     selected: wFilterTH,
                     data: [
                       DropdownItem(value: '-1', title: 'Tất cả'),
                       DropdownItem(value: '0', title: 'Không thời hạn'),
                       DropdownItem(value: '1', title: 'Tháng'),
                       DropdownItem(value: '2', title: 'Quý'),
                       DropdownItem(value: '3', title: 'Năm'),
                       DropdownItem(value: '4', title: 'Dùng thử (3N)'),
                     ],
                     onChanged: (val) {
                       ref.read(hdFilterTH.notifier).state = val!;
                       // hdTable.filter(wLstHD,thang: val);
                     },
                     width: 150,
                   ),
                   const Gap(15),
                   Text('DN'),
                   Checkbox(value: wFilterDN, onChanged: (val){
                     ref.read(hdFilterDN.notifier).state = val!;
                   }),
                   const Gap(15),
                   FilledButton(onPressed: ()=>_onFilter(wLstHD,wFilterTH,wFilterDN,hdTable), child: Text('Ok'))

                 ],
               ),
              ],
            ),
          ),
        ),
        Expanded(
          child: PlutoGrid(
            columns: _columns,
            rows: [],
            rowColorCallback: (e) {
              DateTime dateNow = DateTime.now();
              DateTime dateHH = Helper.dMytoDate(e.row.cells['NgayHetHan']!.value);
              if (e.row.cells['DaKichHoat']!.value == 0) {
                return Colors.yellow.shade50;
              }

              if(dateHH.difference(dateNow).inDays < 3){
                  return Colors.red.shade50;
              }
              return Colors.white;
            },
            onLoaded: (e) {
              e.stateManager.setShowLoading(true);
              e.stateManager.columnFooterHeight = 25;
              e.stateManager.addListener(() {
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
          ),
        ),
      ],
    );
  }

  final List<PlutoColumn> _columns = [
    ConfigPluto.column(
        title: 'Ngày hết hạn',
        field: 'NgayHetHan',
        type: PlutoColumnType.date(format: 'dd/MM/yyyy', popupIcon: null),
        width: 100),
    ConfigPluto.column(
        title: 'MaHD',
        field: 'MaHD',
        width: 50,
        type: const PlutoColumnTypeText(),
        textAlign: PlutoColumnTextAlign.center,
        footerRenderer: (e) {
          return PlutoAggregateColumnFooter(
              padding: const EdgeInsets.only(right: 5),
              alignment: Alignment.center,
              rendererContext: e,
              type: PlutoAggregateColumnType.count);
        }),
    ConfigPluto.column(
        title: 'Tên gọi',
        field: 'TenGoi',
        width: 100,
        type: const PlutoColumnTypeText()),
    ConfigPluto.column(
        title: 'Tên mở rộng',
        field: 'TenMoRong',
        type: const PlutoColumnTypeText(),
        width: 150),
    ConfigPluto.column(
        title: 'Tên Cty',
        field: 'TenCty',
        width: 100,
        type: const PlutoColumnTypeText()),
    ConfigPluto.column(
        title: 'MaSP',
        field: 'MaSP',
        width: 70,
        type: const PlutoColumnTypeText()),
    ConfigPluto.column(
        title: 'MaSPCT',
        field: 'MaSPCT',
        width: 80,
        type: const PlutoColumnTypeText()),
    ConfigPluto.column(
        title: 'Mã kích hoạt',
        field: 'MaKichHoat',
        width: 130,
        renderer: (e){
          return InkWell(
            onDoubleTap: (){
              Clipboard.setData(ClipboardData(text: e.cell.value));
              SmartAlert().showSuccess('Copy thành công');
            },
            child: Text(e.cell.value,style: TextStyle(
              fontSize: 12,
              overflow: TextOverflow.ellipsis
            ),),
          );
        },
        type: const PlutoColumnTypeText()),

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
    ConfigPluto.column(
      title: 'Mô tả',
      field: 'MoTa',
      width: 100,
      type: const PlutoColumnTypeText(),
    ),
    ConfigPluto.column(
      title: 'Thời hạn',
      field: 'ThoiHan',
      width: 100,
      type: const PlutoColumnTypeText(),
    ),
    ConfigPluto.column(
        title: 'Ngày truy cập',
        field: 'NgayTruyCap',
        type: PlutoColumnType.date(format: 'dd/MM/yyyy', popupIcon: null),
        width: 100),
    ConfigPluto.column(
        title: 'Seri',
        field: 'Seri',
        width: 80,
        type: const PlutoColumnTypeText()),
    ConfigPluto.column(
        title: 'SNCL',
        field: 'Con',
        width: 50,
        textAlign: PlutoColumnTextAlign.center,
        hide: true,
        type: PlutoColumnType.number()),
    ConfigPluto.column(
        title: 'DaKichHoat',
        field: 'DaKichHoat',
        type: PlutoColumnType.text(),
        hide: true),
    ConfigPluto.column(
        title: 'DN',
        field: 'DN',
        width: 50,
        type: PlutoColumnType.text(),
        hide: true),
  ];
}
