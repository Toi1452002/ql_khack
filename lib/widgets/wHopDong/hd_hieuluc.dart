import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../providers/providers.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as sh;

class HdHieuluc extends ConsumerStatefulWidget {
  HdHieuluc({super.key});

  @override
  HdHieulucState createState() => HdHieulucState();
}

class HdHieulucState extends ConsumerState<HdHieuluc> {
  late TrinaGridStateManager stateManager;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void onLoad() async{
    stateManager.removeAllRows();
    final data = await HopdongData().getViewHopDong(hl: 0);
    if(data.statusCode == 200){
      List x = jsonDecode(data.data);
      final hd = x.map((e)=>Hopdong.fromMap(e)).toList();
      if(hd.isNotEmpty){
        stateManager.appendRows(hd.map((e)=>TrinaRow(cells: {
          'null': TrinaCell(value: ''),
          'dl': TrinaCell(value: e.maHD),
          'MaHD': TrinaCell(value: e.maHD),
          'MaSP': TrinaCell(value: e.maSP),
          'TenMoRong': TrinaCell(value: e.tenMoRong),
          // 'TenMoRong': TrinaCell(value: e.tenMoRong),
        })).toList());
      }
    }
  }

  void _onClose(BuildContext context) {
    Navigator.pop(context);
  }

  void _updateHieuLuc(WidgetRef ref, int id) {
    SmartAlert().showInfo('Hợp đồng này sẽ có hiệu lực trở lại', onConfirm: () {
      ref.read(hopdongProvider.notifier).onUpdateHieuLuc(id);
    });
  }

  void _deleteHopDong(WidgetRef ref, BuildContext context, int id) {
    final txtPassword = TextEditingController();
    final user = ref.watch(userProvider);
    SmartAlert().showInfo('Hợp đồng này sẽ bị xóa vĩnh viễn', onConfirm: () {
      ref.read(hopdongProvider.notifier).onDeleteHopDong(id).whenComplete(() {
        // Navigator.pop(context);
        // ref.refresh(hopdongProvider);
        // SmartAlert().showSuccess('Xóa thành công!');
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final wListHopDong = ref.watch(lstHopDongProvider).where((e) => e.hieuLuc == false).toList();
    final wListKhach = ref.watch(lstKhachProvider).map((e) => {'id': e.ID, 'tenMoRong': e.tenMoRong}).toList();


    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
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
      // body: DataGrid(onLoaded: (e) {
      //   stateManager = e.stateManager;
      //   onLoad();
      // }, columns: [
      //   DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
      //   DataGridColumn(title: ['', 'dl'], width: 25, render: TypeRender.delete,onTapDelete: (id,re){
      //     _deleteHopDong(ref, context, id,re!);
      //
      //   }),
      //   DataGridColumn(title: ['MaHD', 'MaHD'], width: 80),
      //   DataGridColumn(title: ['MaSP', 'MaSP'], width: 80),
      //   DataGridColumn(title: ['Tên mở rộng', 'TenMoRong'], width: 200),
      //   // DataGridColumn(title: ['Ngày tạo', 'NgayTao'], width: 100),
      //   // DataGridColumn(title: ['Ngày hết HL','NgayTao'],width: 50),
      // ]).withPadding(all: 10),
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
            DataCell(Text(Helper.dMy(hd.dateCreated))),
            DataCell(Text(Helper.dMy(hd.dateModified))),
            DataCell(const Icon(Icons.play_for_work,color: Colors.green,),onTap: ()=>_updateHieuLuc(ref, hd.id!)),
            DataCell(const Icon(Icons.delete,color: Colors.red,),onTap: ()=>_deleteHopDong(ref,context, hd.id!)),
          ]);
        }),
      ),
    );
  }
}

