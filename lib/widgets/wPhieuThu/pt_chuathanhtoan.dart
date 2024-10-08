import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/widgets/wPhieuThu/pt_edit_phieuthu.dart';
import 'package:ql_khach/widgets/wPhieuThu/pt_xacnhan_thanhtoan.dart';
import 'package:ql_khach/widgets/widgets.dart';

import '../../data/data.dart';
import '../../utils/utils.dart';

class PtChuathanhtoan extends ConsumerStatefulWidget {
  const PtChuathanhtoan({super.key});

  @override
  PtChuathanhtoanState createState() => PtChuathanhtoanState();
}

void _showEdit(Phieuthu pt, BuildContext context){
  showDialog(context: context, builder: (context){
    return Dialog(
      alignment: Alignment.topCenter,
      insetPadding: EdgeInsets.symmetric(vertical: 50,horizontal: 5),
      child: PtEditPhieuthu(phieuthu: pt,),
    );
  });
}
void _showXacNhan(
    BuildContext context, String ngayThu, int phieuThu, String dsThang) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
          alignment: Alignment.topCenter,
          child: PtXacnhanThanhtoan(
            ngayThu: ngayThu,
            phieuThu: phieuThu,
            dsThang: dsThang,
          ),
        );
      });
}

class PtChuathanhtoanState extends ConsumerState<PtChuathanhtoan> {
  final colorMain = Colors.orange;
  final FocusNode _focusNode = FocusNode();
  final List<int> _select = [];

  void _onXacNhanTTTT(WidgetRef ref) {
    _focusNode.requestFocus();
    SmartAlert().showInfo('Xác nhận đã thanh toán?', focusNode: _focusNode,
        onConfirm: () {
      ref.read(phieuThuProvider.notifier).onXacNhanTT(_select, isTTTT: true);
    });
  }

  final checkBoxTheme = CheckboxThemeData(
      side: const BorderSide(width: .3),
      fillColor: WidgetStatePropertyAll(Colors.orange.shade600));

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final wChuaThanhToan = ref.watch(ptChuaThanhToanPVD);
    final tongChuaTT = wChuaThanhToan.fold(0, (a, b) => a + b.soTien.toInt());

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Scaffold(
        bottomNavigationBar: SizedBox(
          height: 40,
          child: ColoredBox(
            color: colorMain.shade700,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  ElevatedButton(
                      onPressed: _select.isEmpty ? null :  () => _onXacNhanTTTT(ref),
                      child: Text('Xác nhận (${_select.length})')),
                  const Spacer(),
                  Text(
                    'Tổng: ',
                    style: textTheme.titleMedium!.copyWith(color: Colors.white),
                  ),
                  Wtextfield(
                    style: textTheme.titleSmall,
                    readOnly: true,
                    width: 150,
                    controller: TextEditingController(
                      text: Helper.formatNum(tongChuaTT.toDouble()),
                    ),
                    textAlign: TextAlign.end,
                  )
                ],
              ),
            ),
          ),
        ),
        body: DataTable2(
          showCheckboxColumn: true,
          minWidth: 1000,
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
          headingRowColor: WidgetStatePropertyAll(Colors.yellow.shade100),
          empty: Center(
              child: Text(
            'No data',
            style: textTheme.titleMedium!.copyWith(color: colorMain.shade900),
          )),
          columns: const [
            // DataColumn2(label: Text(''), fixedWidth: 20),
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
            DataColumn2(label: Text('Người nộp')),
            DataColumn2(label: Text('Người thu')),
            DataColumn2(label: Text('Nội dung')),
            DataColumn2(label: Text('Số tiền'), numeric: true, fixedWidth: 80),
          ],
          rows: List.generate(
            wChuaThanhToan.length,
            (i) => DataRow2(
                selected: _select.contains(wChuaThanhToan[i].id),
                onSelectChanged: (val) {
                  if (_select.contains(wChuaThanhToan[i].id)) {
                    _select.remove(wChuaThanhToan[i].id);
                  } else {
                    _select.add(wChuaThanhToan[i].id!);
                  }
                  setState(() {});
                },
                cells: [
                  // DataCell(
                  //   InkWell(
                  //     onTap: () {
                  //       _showXacNhan(
                  //           context,
                  //           Helper.dMy(wChuaThanhToan[i].ngayThu),
                  //           wChuaThanhToan[i].id!,
                  //           Helper.My(wChuaThanhToan[i].dsThang));
                  //     },
                  //     child: const Icon(
                  //       Icons.check,
                  //       size: 15,
                  //     ),
                  //   ),
                  // ),
                  DataCell(_itemCenter("${i + 1}")),
                  DataCell(_itemCenter(wChuaThanhToan[i].id.toString()),onTap: (){
                    _showEdit(wChuaThanhToan[i], context);
                  }),
                  DataCell(_itemCenter(wChuaThanhToan[i].hopDongID.toString())),
                  DataCell(Text(Helper.dMy(wChuaThanhToan[i].ngayThu))),
                  DataCell(Text(Helper.My(wChuaThanhToan[i].thang))),
                  DataCell(Text(Helper.My(wChuaThanhToan[i].dsThang))),
                  DataCell(Text(wChuaThanhToan[i].tenMoRong,
                      softWrap: false, overflow: TextOverflow.ellipsis)),
                  DataCell(Text(wChuaThanhToan[i].nguoiNop)),
                  DataCell(Text(wChuaThanhToan[i].nguoiThu)),
                  DataCell(Text(wChuaThanhToan[i].noiDung)),
                  DataCell(Text(Helper.formatNum(wChuaThanhToan[i].soTien))),
                ]),
          ),
        ),
      ),
    );
  }

  _itemCenter(String val) => Align(
        child: Text(val),
        alignment: Alignment.center,
      );
}
