import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ql_khach/data/data.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';

final hhfilterUserPVD = StateProvider.autoDispose<String?>((ref)=>null);
final hhfilterSPCTPVD = StateProvider.autoDispose<String?>((ref)=>null);


class VNguoinhanhh extends ConsumerWidget {
  const VNguoinhanhh({super.key});
  void _onRefresh(WidgetRef ref){
    ref.refresh(hhfilterUserPVD);
    ref.refresh(hhfilterSPCTPVD);
    // ref.refresh(lstHoaHongKhacPVD);
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nguoiNhanHH = ref.watch(lstHoaHongKhacPVD);
    final thangHH = ref.watch(hhSelectThangPVD);
    final userFilter = ref.watch(hhfilterUserPVD);
    final spctFilter = ref.watch(hhfilterSPCTPVD);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: nguoiNhanHH.when(data: (data) {
        final lstThang = data.map((e)=>Helper.My(e.hoaHongThang)).toSet().toList();

        data = data.where((e){
          bool thang = Helper.My(e.hoaHongThang)==thangHH;
          bool user = userFilter==null || e.user==userFilter;
          bool maSPCT = spctFilter==null || e.maSPCT==spctFilter;
          return thang && user && maSPCT;
        }).toList();
        final tongHoaHong = data.fold(0, (a,b)=>a+b.hoaHong.toInt());
        return Scaffold(

          body: Container(
            decoration:
            BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
            alignment: Alignment.centerLeft,
            width: 840,
            child: Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                title: Row(
                  children: [
                    const Text('Tháng ',style: TextStyle(fontSize: 15),),
                    Wdropdown(
                      width: 100,
                      height: 25,
                      search: true,

                      selected: ref.watch(hhSelectThangPVD),
                      onChanged: (val){
                        _onRefresh(ref);
                        ref.read(hhSelectThangPVD.notifier).state = val!;
                      },
                      data: lstThang.map((e)=>DropdownItem(value: e, title: e)).toList(),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: SizedBox(
                height: 30,
                child: ColoredBox(
                  color: context.colorScheme.primary,
                  child: Row(
                    children: [
                      SizedBox(height: 25,child: FilledButton(onPressed: ()=>_onRefresh(ref), child: const Icon(Icons.refresh))),
                      const Spacer(),
                      Wtextfield(width: 100,readOnly: true,textAlign: TextAlign.end,controller: TextEditingController(text: Helper.formatNum(tongHoaHong.toDouble()))),
                    ],
                  ),
                ),
              ),
              body: Wdatatable(columns: [
                TitleColumn(text: '', width: 40),
                TitleColumn(text: 'Phieu thu ID',width: 100),
                TitleColumn(text: 'MaHD',width: 50),
                TitleColumn(text: 'User',width: 100),
                TitleColumn(text: 'NgayThu',width: 100),
                TitleColumn(text: 'Hoa hong thang',width: 100),
                TitleColumn(text: 'Noi dung',width: 150),
                TitleColumn(text: 'MaSPCT',width: 100),
                TitleColumn(text: 'HoaHong',width: 100,isNumber: true),
              ], rows: _rows(data, ref)),
            ),
          ),
        );
      }, error: (e, s) {
        return Center(
          child: Text(e.toString()),
        );
      }, loading: () {
        return Center(
            child: SpinKitRipple(
              color: context.colorScheme.primary,
              size: 100.0,
            ));
      }),
    );
  }

  List<DataRow2> _rows(List<Hoahong> data, WidgetRef ref) {
    List<String> lstUser = data.map((e)=>e.user).toSet().toList();
    List<String> lstMaSPCT = data.map((e)=>e.maSPCT).toSet().toList();
    lstUser.insert(0, '');
    lstMaSPCT.insert(0, '');
    List<DataRow2> rows = [];
    rows.add(
       DataRow2(cells: [
        const DataCell(SizedBox()),
        const DataCell(SizedBox()),
        const DataCell(SizedBox()),
        DataCell(Wdropdown(
          search: true,
          height: 25,
          selected: ref.watch(hhfilterUserPVD),
          onChanged: (val){
            ref.read(hhfilterUserPVD.notifier).state = val!.isEmpty ? null : val;
          },
          data:lstUser.map((e)=>DropdownItem(value: e, title: e)).toList(),
        )),
        const DataCell(SizedBox()),
        DataCell(SizedBox()),
        const DataCell(SizedBox()),
        DataCell(Wdropdown(
          search: true,
          height: 25,
          selected: ref.watch(hhfilterSPCTPVD),
          onChanged: (val){
            ref.read(hhfilterSPCTPVD.notifier).state = val!.isEmpty ? null : val;
          },
          data: lstMaSPCT.map((e)=>DropdownItem(value: e, title: e)).toList(),
        )),
        const DataCell(SizedBox()),
      ])
    );

    rows.addAll(List.generate(data.length, (i) {
      final hh = data[i];
      return DataRow2(
          color: i % 2 == 0 ? WidgetStatePropertyAll(Colors.grey.shade50) : null,
          cells: [
            DataCell(_cell("${i + 1}",center: true),),
            DataCell(_cell(hh.phieuThuID.toString())),
            DataCell(_cell(hh.maHD.toString())),
            DataCell(_cell(hh.user.toString())),
            DataCell(_cell(Helper.dMy(hh.ngayThu))),
            DataCell(_cell(Helper.My(hh.hoaHongThang))),
            DataCell(_cell(hh.noiDung.toString())),
            DataCell(_cell(hh.maSPCT.toString())),
            DataCell(_cell(Helper.formatNum(hh.hoaHong),isNumber: true)),
          ]);
    }));
    return rows;
  }

  _cell(String text,{bool center = false, bool isNumber = false}) {
    AlignmentGeometry alignment = Alignment.centerLeft;
    if(center) alignment = Alignment.center;
    if(isNumber) alignment = Alignment.centerRight;
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Text(text),
      ),
    );
  }
}
