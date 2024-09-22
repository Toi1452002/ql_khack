import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';

import '../../data/data.dart';

class KhachNgungTd extends ConsumerWidget {
  const KhachNgungTd({super.key});
  void _onClose(BuildContext context){
    Navigator.pop(context);
  }

  List<DataRow2> _rows(List<Khach> lstKhach, WidgetRef ref, BuildContext context){
    List<DataRow2> row = [];
    final user = ref.watch(userProvider);
    row.addAll(List.generate(lstKhach.length, (i){
      Khach k = lstKhach[i];
      return DataRow2(cells: [
        DataCell(Align(alignment: Alignment.center,child: Text("${i+1}"))),
        DataCell(Text(k.maKH.toString())),
        DataCell(Text(k.tenGoi.toString())),
        DataCell(Text(k.tenMoRong.toString())),
        DataCell(Text(k.diaChi.toString())),
        DataCell(Text(k.dienThoai.toString())),
        DataCell(Text(Helper.dMy(k.dateCreated!))),
        DataCell(Text(Helper.dMy(k.dateModified!))),
        DataCell(onTap: (){
          SmartAlert().showInfo('Theo dõi khách này?',onConfirm: (){
            ref.read(dsKNTDProvider.notifier).onUpdateTheoDoi(k.maKH).whenComplete((){
              ref.refresh(dsKNTDProvider);
            });
          });
        },Align(alignment: Alignment.center,child: Tooltip(message: 'Theo dõi',child: Icon(Icons.play_for_work,color: Colors.green)))),
        DataCell(onTap: (){
          final txtPassword = TextEditingController();
          showDialog(context: context, builder: (context){
            return Dialog(
              child: Container(
                color: Colors.yellow.shade50,
                padding: EdgeInsets.all(10),
                width: 300,
                height: 50,
                child: Row(children: [
                  Wtextfield(hintText: 'Xác minh mật khẩu để xóa',width: 200,autofocus: true,controller: txtPassword,obscureText: true,),
                  Spacer(),
                  ElevatedButton(onPressed: (){
                    if(txtPassword.text == user!.password){
                      SmartAlert().showInfo('Sau khi xóa toàn bộ hợp đồng của khách này cũng sẽ mất ',onConfirm: (){
                        ref.read(dsKNTDProvider.notifier).onDeleteKhach(k.maKH).whenComplete((){
                          Navigator.pop(context);
                          ref.refresh(dsKNTDProvider);
                          SmartAlert().showSuccess('Xóa thành công!');

                        });
                      });
                    }else{
                      Navigator.pop(context);
                      SmartAlert().showInfo('Xóa thất bại!');
                    }
                  }, child: Text('Ok'))
                ],),
              ),
            );
          });
        },Align(alignment: Alignment.centerLeft,child: Tooltip(message: 'Delete',child: Icon(Icons.delete,color: Colors.red,)))),
      ]);

    }));

    return row;
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wDsKhachNTD = ref.watch(dsKNTDProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: context.colorScheme.primary,
        actions: [
          InkWell(
              onTap: () => _onClose(context),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              )),
          const Gap(5),
        ],
        elevation: 0,
        titleSpacing: 5,
        title: Text(
          'Khách ngưng theo dõi',
          style: context.textTheme.titleSmall!.copyWith(color: Colors.white),
        ),
        leadingWidth: 40,
      ),

      body: Consumer(
        builder: (context, ref, child){
          if(wDsKhachNTD is DsKntdLoading){
            return const Center(child: CircularProgressIndicator());
          }
          else if (wDsKhachNTD is DsKntdLoaded){
            return  DataTable2(
              minWidth: 700,
              border: TableBorder.all(color: context.colorScheme.primary, width: .5),
              headingTextStyle: context.textTheme.titleSmall!
                  .copyWith(fontSize: 12, color: Colors.blue.shade900),
              dataTextStyle: context.textTheme.bodySmall!.copyWith(fontSize: 12),
              headingRowColor: WidgetStatePropertyAll(context.colorScheme.primary.withOpacity(.1)),
              headingRowHeight: 25,
              dataRowHeight: 25,
              columnSpacing:5,
              horizontalMargin: 2,
              empty: Center(child: Text('No Data',style: context.textTheme.titleSmall,),),
              rows: _rows(wDsKhachNTD.lstKhach,ref,context),
              columns: [
                const DataColumn2(label: Text(''),fixedWidth: 30),
                DataColumn2(label: _title('MaKH'),fixedWidth: 60),
                DataColumn2(label: _title('Tên gọi'),fixedWidth: 100),
                DataColumn2(label: _title('Tên mở rộng'),fixedWidth: 150),
                DataColumn2(label: _title('Địa chỉ')),
                DataColumn2(label: _title('Điện thoại')),
                DataColumn2(label: _title('Ngày tạo'),fixedWidth: 80),
                DataColumn2(label: _title('Ngày nghỉ'),fixedWidth: 80),
                const DataColumn2(label: Text(''),fixedWidth: 30),
                const DataColumn2(label: Text(''),fixedWidth: 30),
              ],
            );
          }else if(wDsKhachNTD is DsKntdError){
            return Center(child: Text(wDsKhachNTD.message),);
          }
          return SizedBox();
        },
      ),

    );
  }
  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Text(text),
    );
  }
}