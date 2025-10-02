import 'package:flutter/services.dart';
import 'package:ql_khach/application/application.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/utils/alert.dart';
import 'package:ql_khach/utils/helper.dart';
import 'package:ql_khach/views/hopdong/giahan_view.dart';
import 'package:ql_khach/views/hopdong/makichhoat_view.dart';
import 'package:ql_khach/views/hopdong/thongtinhopdong_view.dart';
import 'package:ql_khach/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:flutter/material.dart' as mt;

class HopDongView extends ConsumerStatefulWidget {
  const HopDongView({super.key});

  @override
  ConsumerState createState() => _HopDongViewState();
}

class _HopDongViewState extends ConsumerState<HopDongView> {
  late TrinaGridStateManager stateManager;
  List<Hopdong> lstHopDong = [];
  int hieuLuc = 1;
  int thoiHan = 1;
  bool dN = false;
  bool hideFilter = true;

  @override
  Widget build(BuildContext context) {
    ref.listen(hopDongProvider, (_, state) {
      if (state is HopDongLoading) {
        stateManager.setShowLoading(true);
      } else {
        stateManager.setShowLoading(false);
        if (state is HopDongHasData) {
          lstHopDong = state.data;
          stateManager.removeAllRows();
          stateManager.appendRows(state.data
              .map((e) => TrinaRow(cells: {
                    'null': TrinaCell(value: ''),
                    'NgayHetHan': TrinaCell(value: Helper.dMy(e.ngayHetHan)),
                    'ID': TrinaCell(value: e.id.toString()),
                    'TenGoi': TrinaCell(value: e.tenGoi),
                    'TenMoRong': TrinaCell(value: e.tenMoRong),
                    'MaKichHoat': TrinaCell(value: e.maKichHoat),
                    'TenCty': TrinaCell(value: e.tenCty),
                    'MaSP': TrinaCell(value: e.maSP),
                    'MaSPCT': TrinaCell(value: e.maSPCT),
                    'Phi': TrinaCell(value: e.phi),
                    'ThucThu': TrinaCell(value: e.thucThu),
                    'MoTa': TrinaCell(value: e.moTa),
                    'NgayTruyCap': TrinaCell(value: Helper.dMy(e.ngayTruyCap)),
                    'dl': TrinaCell(value: e.id),
                    'ma': TrinaCell(value: e.id),
                    'SoNgayConLai': TrinaCell(value: e.soNgayConLai)
                  }))
              .toList());
        } else if (state is HopDongError) {
          SmartAlert().showError(state.message);
        }
      }
    });

    return Scaffold(
        backgroundColor: context.theme.colorScheme.chart3,
        headers: [
          AppBar(
            backgroundColor: context.theme.colorScheme.chart3,
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            leading: [
              SecondaryButton(
                child: Text('Thêm'),
                onPressed: () {
                  ThongTinHopDongView.show(context, close: () {
                    if (ref.watch(hopDongSubmitProvider)) {
                      ref.read(hopDongProvider.notifier).getHopDong(hieuLuc: hieuLuc, thoiHan: thoiHan, dN: dN ? 1 : 0);
                      ref.read(hopDongSubmitProvider.notifier).state = false;
                    }
                  });
                },
                size: ButtonSize.small,
              ),
              // Gap(44),
              Combobox(
                value: hieuLuc,
                items: [
                  ComboboxItem(value: 0, text: ['Hết hiệu lực']),
                  ComboboxItem(value: 1, text: ['Còn hiệu lực']),
                ],
                onChanged: (val) {
                  ref.read(hopDongProvider.notifier).getHopDong(hieuLuc: val, thoiHan: thoiHan, dN: dN ? 1 : 0);

                  setState(() {
                    hieuLuc = val;
                  });
                },
              ).sized(width: 130),
            ],
            trailing: [
              SecondaryButton(
                onPressed: () {
                  setState(() {
                    hideFilter = !hideFilter;
                  });
                },
                size: ButtonSize.small,
                child: Icon(Icons.filter_alt),
              ),
              SecondaryButton(
                onPressed: () {
                  // stateManager.clearAllColumnFilters();
                  ref.read(hopDongProvider.notifier).getHopDong(hieuLuc: hieuLuc, thoiHan: thoiHan, dN: dN ? 1 : 0);
                },
                size: ButtonSize.small,
                child: Icon(Icons.refresh),
              )
            ],
          ),
          AppBar(
            backgroundColor: context.theme.colorScheme.chart3,
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            leading: [
              Text(
                'Thời hạn',
                style: TextStyle(color: Colors.white),
              ),
              Gap(3),
              Combobox(
                value: thoiHan,
                items: [
                  ComboboxItem(value: -1, text: ['Tất cả']),
                  ComboboxItem(value: 0, text: ['Không thời hạn']),
                  ComboboxItem(value: 1, text: ['Tháng']),
                  ComboboxItem(value: 2, text: ['Quý']),
                  ComboboxItem(value: 3, text: ['Năm']),
                  ComboboxItem(value: 4, text: ['Dùng thử (3N)']),
                ],
                onChanged: (val) {
                  ref.read(hopDongProvider.notifier).getHopDong(hieuLuc: hieuLuc, thoiHan: val, dN: dN ? 1 : 0);

                  setState(() {
                    thoiHan = val;
                  });
                },
              ).sized(width: 130),
              Checkbox(
                state: dN ? CheckboxState.checked : CheckboxState.unchecked,
                onChanged: (val) {
                  ref
                      .read(hopDongProvider.notifier)
                      .getHopDong(hieuLuc: hieuLuc, thoiHan: thoiHan, dN: val.index == 0 ? 1 : 0);

                  setState(() {
                    dN = val.index == 0;
                  });
                },
                trailing: Text(
                  'DN',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          )
        ],
        child: DataGrid(
          hideFilter: hideFilter,
          onLoaded: (e) {
            stateManager = e.stateManager;
            // stateManager.setShowColumnFilter(true);
            stateManager.columnFooterHeight = 25;
          },
          onRowDoubleTap: (event) {
            final field = event.cell.column.field;
            if (field == "MaKichHoat") {
              try{
                Clipboard.setData(ClipboardData(text: event.cell.value)).then((val){
                  SmartAlert().showSuccess('Copy thành công');
                });
              }catch(e){
                SmartAlert().showError(e.toString());
              }


            } else if (field == 'ID') {
              final hd = lstHopDong.firstWhere((e) => e.id.toString() == event.cell.value);
              ThongTinHopDongView.show(context, hopDong: hd, close: () {
                if (ref.watch(hopDongSubmitProvider)) {
                  ref.read(hopDongProvider.notifier).getHopDong(hieuLuc: hieuLuc, thoiHan: thoiHan, dN: dN ? 1 : 0);
                  ref.read(hopDongSubmitProvider.notifier).state = false;
                }
              });
            } else if (field == "NgayHetHan") {
              final hd = lstHopDong.firstWhere((e) => e.id.toString() == event.row.cells['ID']?.value);
              GiaHanView.show(context, hd, onClose: () {
                if (ref.watch(hopDongSubmitProvider)) {
                  ref.read(hopDongProvider.notifier).getHopDong(hieuLuc: hieuLuc, thoiHan: thoiHan, dN: dN ? 1 : 0);
                  ref.read(hopDongSubmitProvider.notifier).state = false;
                }
              });
            }
          },
          rowColorCallback: (e) {
            final sN = e.row.cells['SoNgayConLai']?.value;
            if (sN != null && sN <= 3) {
              return Colors.red.shade100;
            }
            return Colors.white;
          },
          columns: [
            DataGridColumn(
                title: ['', 'null'],
                width: 40,
                render: TypeRender.numIndex,
                frozen: true,
                showFooter: true,
                typeFooter: TypeFooter.count,
                enableFilter: false),
            DataGridColumn(
                title: ['Ngày hết hạn', 'NgayHetHan'],
                width: 120,
                columnAlign: ColumnAlign.center,
                textStyle: ColumnTextStyle.redBlack()),
            DataGridColumn(
                title: ['ID', 'ID'], width: 50, columnAlign: ColumnAlign.center, textStyle: ColumnTextStyle.red()),
            DataGridColumn(title: ['Tên gọi', 'TenGoi'], width: 100),
            DataGridColumn(title: ['Tên mở rộng', 'TenMoRong'], width: 200),
            DataGridColumn(title: ['Mã kích hoạt', 'MaKichHoat'], width: 200, textStyle: ColumnTextStyle.blue()),
            DataGridColumn(title: ['Tên Cty', 'TenCty'], width: 100),
            DataGridColumn(title: ['MaSP', 'MaSP'], width: 70, columnAlign: ColumnAlign.center),
            DataGridColumn(title: ['MaSPCT', 'MaSPCT'], width: 90, columnAlign: ColumnAlign.center),
            DataGridColumn(title: ['Phí', 'Phi'], width: 80, columnType: ColumnType.num, showFooter: true),
            DataGridColumn(title: ['Thực thu', 'ThucThu'], width: 90, columnType: ColumnType.num, showFooter: true),
            DataGridColumn(title: ['Mô tả', 'MoTa'], width: 150),
            DataGridColumn(title: ['Ngày truy cập', 'NgayTruyCap'], width: 130, columnAlign: ColumnAlign.center),
            DataGridColumn(title: ['SoNgayConLai', 'SoNgayConLai'], hide: true, columnType: ColumnType.num),
            DataGridColumn(
                title: ['', 'dl'],
                width: 25,
                render: TypeRender.delete,
                enableFilter: false,
                onTapDelete: (id, re) {
                  SmartAlert().showInfo('Có chắc muốn xóa', onConfirm: () async {
                    final result = await ref.read(hopDongProvider.notifier).onDeleteHopDong(id);
                    if (result) {
                      re?.stateManager.removeCurrentRow();
                    }
                  });
                }),
            DataGridColumn(
                title: ['', 'ma'],
                width: 25,
                enableFilter: false,

                renderer: (re) {
                  return mt.InkWell(
                    onTap: () {
                      re.stateManager.setKeepFocus(true);
                      re.stateManager.setCurrentCell(re.cell, re.rowIdx);
                      MaKichHoatView.show(context, maHD: re.cell.value,);
                    },
                    child: Icon(
                      Icons.code,
                      size: 20,
                      color: Colors.gray,
                    ),
                  );
                }),
          ],
        ).withPadding(all: 10));
  }
}
