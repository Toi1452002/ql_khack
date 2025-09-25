import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/hoahong/hoahong_provider.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/helper.dart';
import 'package:ql_khach/views/bangtinhhoahong/bangtinhhoahong_function.dart';
import 'package:ql_khach/widgets/data_grid/data_grid.dart';
import 'package:ql_khach/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_validator/string_validator.dart';
import 'package:trina_grid/trina_grid.dart';

class BangTinhHoaHongView extends ConsumerStatefulWidget {
  const BangTinhHoaHongView({super.key, required this.maPT, required this.soTien, required this.maSP});

  final int maPT;
  final String maSP;
  final String soTien;

  static const name = "Bảng tính hoa hồng";

  static void show(BuildContext context, int maPT, String soTien, String maSP) => showCustomDialog(context,
      title: name.toUpperCase(),
      width: 880,
      height: 500,
      child: BangTinhHoaHongView(
        maPT: maPT,
        soTien: soTien,
        maSP: maSP,
      ));

  @override
  ConsumerState createState() => _BangTinhHoaHongViewState();
}

class _BangTinhHoaHongViewState extends ConsumerState<BangTinhHoaHongView> {
  late TrinaGridStateManager stateManager;
  final fc = BangTinhHoaHongFunction();
  final txtMaPT = TextEditingController();
  final txtTuNam = TextEditingController(text: DateTime.now().year.toString());
  int tuThang = DateTime.now().month;

  List<User> lstUser = [];
  List<int> userSelected = [];
  List<dynamic> lstHoaHong = [];

  @override
  void initState() {
    // TODO: implement initState
    onLoad();
    super.initState();
  }

  onLoad() async {
    lstUser = await fc.getUser();
    setState(() {});
  }

  onLoadData() async {
    stateManager.removeAllRows();
    final data = await fc.getBangTinhHoaHong(ref, widget.maPT);
    if (data.isNotEmpty) {
      lstHoaHong = data;
      stateManager.appendRows(data
          .map((e) => TrinaRow(cells: {
                'null': TrinaCell(value: toInt(e['ID'].toString())),
                'dl': TrinaCell(value: toInt(e['ID'].toString())),
                'ID': TrinaCell(value: e['ID'].toString()),
                'User': TrinaCell(value: e['User']),
                'Thang': TrinaCell(value: Helper.My(e['HoaHongThang'])),
                'NoiDung': TrinaCell(value: toString(e['NoiDung'])),
                'HoaHong': TrinaCell(value: toDouble(e['HoaHong'].toString())),
              }))
          .toList());
    }
  }

  onAddRow() async {
    final result = await fc.addHang(userSelected, widget.maPT, ref, tuT: tuThang, tN: txtTuNam.text,lstHH: lstHoaHong);
    if (result) {
      onLoadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final edit = ref.read(userProvider)!.level > 1;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration:  BoxDecoration(border: Border.all(width: .1)),
          width: 250,
          child: Column(
            spacing: 10,
            children: [
              WidgetCustomRow(columnWidths: const {
                0: 100
              }, items: [
                const Text('Mã phiếu thu').medium,
                WidgetTextField(
                  enabled: false,
                  controller: TextEditingController(text: widget.maPT.toString()),
                ),
              ]),
              WidgetCustomRow(columnWidths: const {
                0: 100
              }, items: [
                const Text('Mã SP').medium,
                WidgetTextField(
                  enabled: false,
                  controller: TextEditingController(text: widget.maSP.toString()),
                ),
              ]),
              WidgetCustomRow(columnWidths: const {
                0: 100
              }, items: [
                const Text('Số tiền').medium,
                WidgetTextField(
                  enabled: false,
                  controller: TextEditingController(text: widget.soTien),
                  textAlign: TextAlign.right,
                ),
              ]),
              WidgetCustomRow(columnWidths: const {
                0: 100
              }, items: [
                const Text('Tháng HH').medium,
                Combobox(
                  value: tuThang,
                  items: [
                    for (int i = 1; i <= 12; i++) ComboboxItem(value: i, text: ['$i'])
                  ],
                  onChanged: (val) {
                    setState(() {
                      tuThang = val;
                    });
                  },
                ),
                WidgetTextField(
                  controller: txtTuNam,
                  isNumber: true,
                  textAlign: TextAlign.center,
                ),
              ]),
              Expanded(
                  child: OutlinedContainer(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                backgroundColor: Colors.gray.shade100,
                child: ListView.separated(
                  itemCount: lstUser.length,
                  itemBuilder: (context, i) {
                    final user = lstUser[i];
                    return Checkbox(
                      state: userSelected.contains(user.id) ? CheckboxState.checked : CheckboxState.unchecked,
                      onChanged: (val) {
                        setState(() {
                          if (userSelected.contains(user.id)) {
                            userSelected.remove(user.id);
                          } else {
                            userSelected.add(user.id!);
                          }
                        });
                      },
                      trailing: Text(user.fullname),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      height: 10,
                    );
                  },
                ),
              )),
              // Spacer(),
              PrimaryButton(
                enabled: edit,
                onPressed: onAddRow,
                child: const Text('Thêm hàng'),
              )
            ],
          ),
        ),
        DataGrid(
          onLoaded: (e) {
            stateManager = e.stateManager;
            onLoadData();
          },
          onChange: (event) => fc.onChanged(event),
          columns: [
            const DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
            DataGridColumn(
                title: ['', 'dl'],
                width: 25,
                render: TypeRender.delete,
                onTapDelete: (id, re) {
                  if (edit) {
                    fc.deleteRow(id, re!);
                  }
                }),
            DataGridColumn(title: ['ID', "ID"], width: 50, textStyle: ColumnTextStyle.blue()),

            // DataGridColumn(title: ['Ngày thu', 'NgayThu'], width: 80),
            DataGridColumn(
                title: ['Tháng HH', 'Thang'],
                width: 80,
                textStyle: ColumnTextStyle.blue(),
                columnAlign: ColumnAlign.center),
            DataGridColumn(title: ['User', 'User'], width: 90, textStyle: ColumnTextStyle.blue()),
            DataGridColumn(title: ['Nội dung', 'NoiDung'], width: 230, isEdit: edit),
            DataGridColumn(title: ['Hoa hồng', 'HoaHong'], width: 90, isEdit: edit, columnType: ColumnType.num),
          ],
        ).expanded()
      ],
    );
  }
}
