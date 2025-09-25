import 'package:badges/badges.dart';
import 'package:ql_khach/application/application.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/utils/alert.dart';
import 'package:ql_khach/views/khach/thongtinkhach_view.dart';
import 'package:ql_khach/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:trina_grid/trina_grid.dart';

class KhachView extends ConsumerStatefulWidget {
  const KhachView({super.key});

  @override
  ConsumerState createState() => _KhachViewState();
}

class _KhachViewState extends ConsumerState<KhachView> {
  late TrinaGridStateManager stateManager;
  List<Khach> lstKhach = [];

  // int selectedType = 1;
  bool hideFilter = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(khachProvider, (_, state) {
      if (state is KhachLoading) {
        stateManager.setShowLoading(true);
      } else {
        stateManager.setShowLoading(false);
        if (state is KhachHasData) {
          stateManager.removeAllRows();
          lstKhach = state.data;
          stateManager.appendRows(state.data
              .map((e) => TrinaRow(cells: {
                    'null': TrinaCell(value: ''),
                    'dl': TrinaCell(value: e.ID),
                    'ID': TrinaCell(value: e.ID.toString()),
                    'TenGoi': TrinaCell(value: e.tenGoi),
                    'TenMoRong': TrinaCell(value: e.tenMoRong),
                    'DiaChi': TrinaCell(value: e.diaChi),
                    'KhuVuc': TrinaCell(value: e.khuVuc),
                    'DienThoai': TrinaCell(value: e.dienThoai),
                    'SoTien': TrinaCell(value: e.soTien),
                    'NguonLienHe': TrinaCell(value: e.nguonLienHe),
                    'TenCty': TrinaCell(value: e.tenCty),
                    'GhiChu': TrinaCell(value: e.ghiChu),
                  }))
              .toList());
        } else if (state is KhachError) {
          SmartAlert().showError(state.message);
        }
      }
    });

    return Scaffold(
        backgroundColor: context.theme.colorScheme.chart3,
        headers: [
          AppBar(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            backgroundColor: context.theme.colorScheme.chart3,
            leading: [
              SecondaryButton(
                size: ButtonSize.small,
                onPressed: () {
                  ThongTinKhachView.show(context);
                },
                child: Text('Thêm'),
              ),

              Combobox(
                value: ref.watch(khachTheoDoiProvider),
                items: const [
                  ComboboxItem(value: 0, text: ['Ngừng theo dõi']),
                  ComboboxItem(value: 1, text: ['Đang theo dõi']),
                  ComboboxItem(value: 2, text: ['Tất cả']),
                ],
                onChanged: (val) {
                  ref.read(khachProvider.notifier).get(theoDoi: val);
                  ref.read(khachTheoDoiProvider.notifier).state = val;
                },
              ).sized(width: 150)
            ],
            trailing: [
              SecondaryButton(
                size: ButtonSize.small,
                onPressed: () {
                  ref.read(khachProvider.notifier).get(theoDoi: ref.watch(khachTheoDoiProvider));
                },
                child: const Icon(Icons.refresh),
              ),
            ],
          ),
        ],
        child: DataGrid(
          onLoaded: (e) {
            stateManager = e.stateManager;
            stateManager.columnFooterHeight = 25;
            stateManager.setShowColumnFilter(true);
          },
          onRowDoubleTap: (event) {
            if (event.cell.column.field == "ID") {
              final khach = lstKhach.firstWhere((e) => e.ID.toString() == event.cell.value);
              ThongTinKhachView.show(context, khach: khach);
            }
          },
          columns: [


            const DataGridColumn(
                title: ['', 'null'],
                width: 35,
                render: TypeRender.numIndex,
                typeFooter: TypeFooter.count,
                enableFilter: false,
                showFooter: true),
            DataGridColumn(
                title: ['ID', 'ID'], width: 60, textStyle: ColumnTextStyle.red(), columnAlign: ColumnAlign.center,),
            DataGridColumn(title: ['Tên gọi', 'TenGoi'], width: 100),
            DataGridColumn(title: ['Tên mở rộng', 'TenMoRong'], width: 250),
            DataGridColumn(title: ['Địa chỉ', 'DiaChi'], width: 200),
            DataGridColumn(title: ['Khu vực', 'KhuVuc'], width: 100),
            DataGridColumn(title: ['Điện thoại', 'DienThoai'], width: 130),
            DataGridColumn(title: ['Số tiền', 'SoTien'], width: 130, columnType: ColumnType.num, showFooter: true),
            DataGridColumn(title: ['Nguồn liên hệ', 'NguonLienHe'], width: 150),
            DataGridColumn(title: ['Tên Cty', 'TenCty'], width: 100),
            DataGridColumn(title: ['Ghi chú', 'GhiChu'], width: 200),
            DataGridColumn(
                title: ['', 'dl'],
                width: 25,
                enableFilter: false,
                render: TypeRender.delete,
                onTapDelete: (id, re) {
                  SmartAlert().showInfo('Có chắc muốn xóa?', onConfirm: () async {
                    final result = await ref.read(khachProvider.notifier).onDeleteKhach(id);
                    if (result) {
                      re?.stateManager.removeCurrentRow();
                    }
                  });
                }),
          ],
        ).withPadding(all: 10));
  }
}
