import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ql_khach/providers/hopdong/hopdong.dart';
import 'package:ql_khach/providers/khach/ds_khach/ds_khach_provider.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';

import '../../providers/providers.dart';

class HdHieuluc extends ConsumerWidget {
  const HdHieuluc({super.key});

  void _onClose(BuildContext context) {
    Navigator.pop(context);
  }

  void _updateHieuLuc(WidgetRef ref, int id){
    SmartAlert().showInfo('Hợp đồng này sẽ có hiệu lực trở lại',onConfirm: (){
      ref.read(hopdongProvider.notifier).onUpdateHieuLuc(id);
    });
  }


  void _deleteHopDong(WidgetRef ref, BuildContext context, int id){
    final txtPassword = TextEditingController();
    final user = ref.watch(userProvider);

    showDialog(context: context, builder: (context){
      return Dialog(
        child: Container(
          color: Colors.yellow.shade50,
          padding: const EdgeInsets.all(10),
          width: 300,
          height: 50,
          child: Row(children: [
            Wtextfield(hintText: 'Xác minh mật khẩu để xóa',width: 200,autofocus: true,controller: txtPassword,obscureText: true,),
            const Spacer(),
            ElevatedButton(onPressed: (){
              if(txtPassword.text == user!.password){
                SmartAlert().showInfo('Hợp đồng này sẽ bị xóa vĩnh viễn',onConfirm: (){

                  ref.read(hopdongProvider.notifier).onDeleteHopDong(id).whenComplete((){
                    Navigator.pop(context);
                    // ref.refresh(hopdongProvider);
                    // SmartAlert().showSuccess('Xóa thành công!');

                  });
                });
              }else{
                Navigator.pop(context);
                SmartAlert().showInfo('Xóa thất bại!');
              }
            }, child: const Text('Ok'))
          ],),
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wListHopDong =
        ref.watch(lstHopDongProvider).where((e) => e.hieuLuc == false).toList();
    final wListKhach = ref
        .watch(lstKhachProvider)
        .map((e) => {'id': e.maKH, 'tenMoRong': e.tenMoRong})
        .toList();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: context.colorScheme.primary,
        title: Text(
          'Hợp đồng không hiệu lực',
          style: context.textTheme.titleSmall!.copyWith(color: Colors.white),
        ),
        elevation: 0,
        titleSpacing: 5,
        leadingWidth: 40,
        actions: [
          InkWell(
              onTap: () => _onClose(context),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              )),
          const Gap(5),
        ],
      ),
      body: DataTable2(
        minWidth: 700,
        border: TableBorder.all(color: context.colorScheme.primary, width: .5),
        headingTextStyle: context.textTheme.titleSmall!
            .copyWith(fontSize: 12, color: Colors.blue.shade900),
        dataTextStyle: context.textTheme.bodySmall!.copyWith(fontSize: 12),
        headingRowColor:
            WidgetStatePropertyAll(context.colorScheme.primary.withOpacity(.1)),
        headingRowHeight: 25,
        dataRowHeight: 25,
        columnSpacing: 5,
        horizontalMargin: 2,
        columns: [
          const DataColumn2(label: Text(''), fixedWidth: 30),
          const DataColumn2(label: Text('MaHD'), fixedWidth: 60),
          const DataColumn2(label: Text('MaSP'), fixedWidth: 60),
          const DataColumn2(label: Text('Tên mở rộng')),
          const DataColumn2(label: Text('Ngày tạo')),
          const DataColumn2(label: Text('Ngày hết HL')),
          const DataColumn2(label: Text(''), fixedWidth: 30),
          const DataColumn2(label: Text(''), fixedWidth: 30),
        ],
        rows: List.generate(wListHopDong.length, (i) {
          final hd = wListHopDong[i];
          final tenMoRong = wListKhach.firstWhere((e)=>e['id'] == hd.khachID)['tenMoRong'];
          return DataRow2(cells: [
            DataCell(Align(child: Text("${i+1}"),alignment: Alignment.center,)),
            DataCell(Align(child: Text("${hd.id}"),alignment: Alignment.center,)),
            DataCell(Text("${hd.maSP}")),
            DataCell(Text("${tenMoRong}")),
            DataCell(Text(Helper.dMy(hd.dateCreated,hour: true))),
            DataCell(Text(Helper.dMy(hd.dateModified,hour: true))),
            DataCell(const Icon(Icons.play_for_work,color: Colors.green,),onTap: ()=>_updateHieuLuc(ref, hd.id!)),
            DataCell(const Icon(Icons.delete,color: Colors.red,),onTap: ()=>_deleteHopDong(ref,context, hd.id!)),
          ]);
        }),
      ),
    );
  }
}
