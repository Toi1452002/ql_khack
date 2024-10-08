import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/widgets/wPhieuThu/pt_edit_phieuthu.dart';
import 'package:ql_khach/widgets/widgets.dart';

final selectCXNProvider = StateProvider.autoDispose<List<int>>((ref) {
  return [];
});

class PtChuaxacnhan extends ConsumerStatefulWidget {
  const PtChuaxacnhan({super.key});

  @override
  PtChuaxacnhanState createState() => PtChuaxacnhanState();
}

class PtChuaxacnhanState extends ConsumerState<PtChuaxacnhan> {
  final colorMain = Colors.green;
  final List<int> _select = [];
  final FocusNode _focusNode = FocusNode();

  void _showEdit(Phieuthu pt){
    showDialog(context: context, builder: (context){
      return Dialog(
        alignment: Alignment.topCenter,
        insetPadding: EdgeInsets.symmetric(vertical: 50,horizontal: 5),
        child: PtEditPhieuthu(phieuthu: pt,),
      );
    });
  }

  void _onXacNhan(WidgetRef ref) {
    _focusNode.requestFocus();
    SmartAlert().showInfo('Xác nhận đã nhận được?', focusNode: _focusNode,
        onConfirm: () {
      ref.read(phieuThuProvider.notifier).onXacNhanTT(_select);
    });
  }
  final checkBoxTheme = CheckboxThemeData(
    side: const BorderSide(width: .3),
    fillColor: WidgetStatePropertyAll(Colors.green.shade600)

  );
  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final wChuaXacNhan = ref.watch(ptChuaXacNhanPVD);
    final tongChuaXN = wChuaXacNhan.fold(0, (a, b) => a + b.soTien.toInt());
    final userTrueLV = ref.watch(userProvider)!.level > 1;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Scaffold(
        bottomNavigationBar: SizedBox(
          height: 40,
          child: ColoredBox(
            color: colorMain.shade900,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  ElevatedButton(
                      onPressed: _select.isEmpty ? null : (userTrueLV ?  () => _onXacNhan(ref) : null),
                      child: Text('Xác nhận (${_select.length})')),
                  const Spacer(),
                  Text(
                    'Tổng: ',
                    style: textTheme.titleMedium!.copyWith(color: Colors.white),
                  ),
                  Wtextfield(
                    style: textTheme.titleSmall,
                    width: 150,
                    readOnly: true,
                    controller: TextEditingController(
                      text: Helper.formatNum(tongChuaXN.toDouble()),
                    ),
                    textAlign: TextAlign.end,
                  )
                ],
              ),
            ),
          ),
        ),
        body: DataTable2(
            minWidth: 1000,
            showCheckboxColumn: true,
            border: TableBorder.all(color: colorMain, width: .5),
            headingTextStyle: textTheme.titleSmall!
                .copyWith(fontSize: 12, color: colorMain.shade900),
            dataTextStyle: textTheme.bodySmall!.copyWith(fontSize: 12),
            headingRowHeight: 25,
            dataRowHeight: 25,
            columnSpacing: 10,
            horizontalMargin: 5,
            datarowCheckboxTheme: checkBoxTheme,
            headingCheckboxTheme: checkBoxTheme,
            headingRowColor: WidgetStatePropertyAll(colorMain.shade100),
            empty: Center(
                child: Text(
              'No data',
              style: textTheme.titleMedium!.copyWith(color: colorMain.shade900),
            )),
            columns: const [
              DataColumn2(label: Text(''), fixedWidth: 20),
              DataColumn2(label: Text('Phieu'), fixedWidth: 40),
              DataColumn2(label: Text('MaHD'), fixedWidth: 50),
              DataColumn2(label: Text('Ngày thu'), fixedWidth: 100),
              DataColumn2(label: Text('Tháng'), fixedWidth: 80),
              DataColumn2(label: Text('DsThang'), fixedWidth: 80),
              DataColumn2(
                  label: Text(
                'Tên mở rộng',
              )),
              DataColumn2(label: Text('Người nộp'), fixedWidth: 150),
              DataColumn2(label: Text('Người thu'), fixedWidth: 100),
              DataColumn2(label: Text('Nội dung')),
              DataColumn2(
                  label: Text('Số tiền'), numeric: true, fixedWidth: 80),
            ],
            rows: List.generate(
                wChuaXacNhan.length,
                (i) {
                  return DataRow2(
                      selected: _select.contains(wChuaXacNhan[i].id),
                      onSelectChanged: (val) {
                        if (_select.contains(wChuaXacNhan[i].id)) {
                          _select.remove(wChuaXacNhan[i].id);
                        } else {
                          _select.add(wChuaXacNhan[i].id!);
                        }
                        setState(() {});
                      },
                      cells: [
                        DataCell(_itemCenter("${i + 1}")),
                        DataCell(_itemCenter(wChuaXacNhan[i].id.toString()),onTap: (){
                          // print('object');
                          _showEdit(wChuaXacNhan[i]);

                        }),
                        DataCell(_itemCenter(
                            wChuaXacNhan[i].hopDongID.toString())),
                        DataCell(Text(Helper.dMy(
                            wChuaXacNhan[i].ngayThu?.trim()))),
                        DataCell(Text(Helper.My(wChuaXacNhan[i].thang))),
                        DataCell(Text(Helper.My(wChuaXacNhan[i].dsThang))),
                        DataCell(Text(wChuaXacNhan[i].tenMoRong,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis)),
                        DataCell(Text(wChuaXacNhan[i].nguoiNop)),
                        DataCell(Text(wChuaXacNhan[i].nguoiThu)),
                        DataCell(Text(wChuaXacNhan[i].noiDung)),
                        DataCell(
                            Text(Helper.formatNum(wChuaXacNhan[i].soTien))),
                      ]);
                })),
      ),
    );
  }

  _itemCenter(String val) => Align(
        alignment: Alignment.center,
        child: Text(val),
      );
}
