import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ql_khach/providers/providers.dart';
import 'package:ql_khach/utils/utils.dart';
import 'package:ql_khach/widgets/widgets.dart';

import '../../data/data.dart';

final hhSortColumnPVD = StateProvider.autoDispose<int>((ref) =>0);
final hhIsSortPVD = StateProvider.autoDispose<bool>((ref) =>true);

class HhTable extends ConsumerWidget {
  const HhTable({super.key});
  void _onRefresh(WidgetRef ref){
    final user = ref.watch(userProvider);
    ref.read(hoaHongProvider.notifier).onGetHoaHong(ref,user!);
    ref.refresh(filterHoaHongPVD);
    ref.refresh(hhSortColumnPVD);
    ref.refresh(hhSortColumnPVD);
  }
  void  _onFilter(WidgetRef ref){
    final wFilHoaHong = ref.watch(filterHoaHongPVD);
    final wListHHBase = ref.watch(lstHoaHongPVD);

    final rListHHCopy = ref.read(lstHoaHongCopyPVD.notifier);
    rListHHCopy.state = wListHHBase.where((e){
      final bool phieuID = wFilHoaHong.phieuThuID == null || e.phieuThuID.toString() == wFilHoaHong.phieuThuID;
      final bool user = wFilHoaHong.user == null || e.user == wFilHoaHong.user;
      final bool ngayThu = wFilHoaHong.ngayThu == null || e.ngayThu == wFilHoaHong.ngayThu;
      final bool maHD = wFilHoaHong.maHD == null || e.maHD.toString() == wFilHoaHong.maHD;
      final bool hoaHong = wFilHoaHong.hoaHong == null || Helper.formatNum(e.hoaHong) == wFilHoaHong.hoaHong;
      final bool hhThang = wFilHoaHong.hoaHongThang == null || Helper.My(e.hoaHongThang) == wFilHoaHong.hoaHongThang;
      return phieuID && user && ngayThu && maHD && hhThang && hoaHong;
    }).toList();
  }

  List<DataRow2> _rows(List<Hoahong> hh, WidgetRef ref){
    final cbbPhieuID = hh.map((e)=>e.phieuThuID).toSet().toList();
    final cbbMaHD = hh.map((e)=>e.maHD).toSet().toList();
    final cbbUser = hh.map((e)=>e.user).toSet().toList();
    final cbbNgayThu = hh.map((e)=>DateFormat('yyyy-MM-dd').format(DateTime.parse(e.ngayThu))).toSet().toList();
    final cbbHHThang = hh.map((e)=>e.hoaHongThang).toSet().toList();
    final cbbHH = hh.map((e)=>e.hoaHong).toSet().toList();
    final wFilHoaHong = ref.watch(filterHoaHongPVD);
    cbbNgayThu.sort();
    cbbHH.sort();
    List<DataRow2> row = [];
    row.add(DataRow2(cells: [
      const DataCell(Text("")),
      const DataCell(Text("")),
      DataCell(Wdropdown(data: [
        DropdownItem(value: '', title: ''),
        ...cbbPhieuID.map((e)=>DropdownItem(value: e.toString(), title: e.toString()))
      ],height: 25,search: true,selected: wFilHoaHong.phieuThuID,onChanged: (val){
        wFilHoaHong.setPhieuThu = val.toString().isEmpty ? null : val.toString();
        _onFilter(ref);
      },)),
      DataCell(Wdropdown(data: [
        DropdownItem(value: '', title: ''),
        ...cbbMaHD.map((e)=>DropdownItem(value: e.toString(), title: e.toString()))
      ],height: 25,search: true,selected: wFilHoaHong.maHD,onChanged: (val){
        wFilHoaHong.setMaHD = val.toString().isEmpty ? null : val.toString();
        _onFilter(ref);
      },)),
      DataCell(Wdropdown(data: [
        DropdownItem(value: '', title: ''),
        ...cbbUser.map((e)=>DropdownItem(value: e.toString(), title: e.toString()))
      ],height: 25,search: true,selected: wFilHoaHong.user,onChanged: (val){
        wFilHoaHong.setUser = val.toString().isEmpty ? null : val.toString();
        _onFilter(ref);
      },)),
      DataCell(Wdropdown(data: [
        DropdownItem(value: '', title: ''),
        ...cbbNgayThu.map((e)=>DropdownItem(value: e.toString(), title: Helper.dMy(e)))
      ],height: 25,search: true,selected: wFilHoaHong.ngayThu,onChanged: (val){
        wFilHoaHong.setNgayThu = val.toString().isEmpty ? null : val.toString();
        _onFilter(ref);
      },)),
      DataCell(Wdropdown(data: [
        DropdownItem(value: '', title: ''),
        ...cbbHHThang.map((e)=>DropdownItem(value: Helper.My(e), title: Helper.My(e)))
      ],height: 25,search: true,selected: wFilHoaHong.hoaHongThang,onChanged: (val){
        wFilHoaHong.setHHThang = val.toString().isEmpty ? null : val.toString();
        _onFilter(ref);
      },)),
      const DataCell(SizedBox()),
      DataCell(Wdropdown(data: [
        DropdownItem(value: '', title: ''),
        ...cbbHH.map((e)=>DropdownItem(value: Helper.formatNum(e), title: Helper.formatNum(e)))
      ],height: 25,search: true,selected: wFilHoaHong.hoaHong,onChanged: (val){
        wFilHoaHong.setHoaHong = val.toString().isEmpty ? null : val.toString();
        _onFilter(ref);
      },)),
    ]));


    row.addAll(List.generate(hh.length, (i){
      Hoahong data = hh[i];
      return DataRow2(color: i%2!=0 ? WidgetStatePropertyAll(Colors.grey.shade50) : null,cells: [
        DataCell(Align(alignment: Alignment.center,child: Text("${i+1}"))),
        DataCell(_title("${data.id}")),
        DataCell(_title("${data.phieuThuID}")),
        DataCell(_title("${data.maHD}")),
        DataCell(_title(data.user)),
        DataCell(_title(Helper.dMy(data.ngayThu))),
        DataCell(_title(Helper.My(data.hoaHongThang))),
        // DataCell(_title(data.tyleHH == 0 ? '' : data.tyleHH.toStringAsFixed(0))),
        DataCell(_title(data.noiDung)),
        DataCell(_title(data.hoaHong == 0 ? '' :data.hoaHong.toStringAsFixed(0))),
      ]);
    }));
    return row;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = context.textTheme;
    final colorMain = context.colorScheme.primary;
    final wListHH = ref.watch(lstHoaHongCopyPVD);
    final tongHoaHong = wListHH.fold(0, (a,b)=>a+b.hoaHong.toInt());
    final wColumnSort = ref.watch(hhSortColumnPVD);
    final rColumnSort = ref.read(hhSortColumnPVD.notifier);
    final wIsSort = ref.watch(hhIsSortPVD);
    final rIsSort = ref.read(hhIsSortPVD.notifier);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 800,
          decoration: BoxDecoration(
            border: Border.all(color: colorMain,width: 1)
          ),
          child: Scaffold(
            bottomNavigationBar: SizedBox(
              height: 30,
              child: ColoredBox(
                color: colorMain,
                child: Row(
                  children: [
                    SizedBox(height: 25,child: FilledButton(onPressed: ()=>_onRefresh(ref), child: const Icon(Icons.refresh))),
                    const Spacer(),
                    // Wtextfield(width: 80,readOnly: true,textAlign: TextAlign.end,controller: TextEditingController(text: tongTyLe.toString()),),
                    Wtextfield(width: 100,readOnly: true,textAlign: TextAlign.end,controller: TextEditingController(text: Helper.formatNum(tongHoaHong.toDouble()))),
                  ],
                ),
              ),
            ),
            body: DataTable2(
              fixedTopRows: 2,
              minWidth: 700,
              border: TableBorder.all(color: colorMain, width: .5),
              headingTextStyle: textTheme.titleSmall!
                  .copyWith(fontSize: 12, color: Colors.blue.shade900),
              dataTextStyle: textTheme.bodySmall!.copyWith(fontSize: 12),
              headingRowColor: WidgetStatePropertyAll(context.colorScheme.primary.withOpacity(.1)),
              headingRowHeight: 25,
              dataRowHeight: 25,
              columnSpacing: 0,
              horizontalMargin: 0,
              sortAscending: wIsSort,
              sortColumnIndex: wColumnSort,
              columns:  [
                const DataColumn2(label: Text(''),fixedWidth: 20),
                DataColumn2(label: _title('ID'),fixedWidth: 40),
                DataColumn2(label: _title('Phiếu thu ID'),fixedWidth: 80),
                DataColumn2(label: _title('MaHD'),fixedWidth: 60),
                DataColumn2(label: _title('User'),fixedWidth: 100),
                DataColumn2(label: _title('Ngày thu'),fixedWidth: 120,onSort: (i,t){
                  rColumnSort.state = i;
                  if(wIsSort){
                    wListHH.sort((a,b)=>b.ngayThu.compareTo(a.ngayThu));
                  }else{
                    wListHH.sort((a,b)=>a.ngayThu.compareTo(b.ngayThu));

                  }
                  rIsSort.state = !wIsSort;
                }),
                DataColumn2(label: _title('Hoa hồng tháng'),fixedWidth: 120,onSort: (i,t){
                  rColumnSort.state = i;
                  if(wIsSort){
                    wListHH.sort((a,b)=>b.hoaHongThang.compareTo(a.hoaHongThang));
                  }else{
                    wListHH.sort((a,b)=>a.hoaHongThang.compareTo(b.hoaHongThang));

                  }
                  rIsSort.state = !wIsSort;
                }),
                DataColumn2(label: _title('Nội dung'),onSort: (i,t){
                  rColumnSort.state = i;
                  if(wIsSort){
                    wListHH.sort((a,b)=>b.noiDung.compareTo(a.noiDung));
                  }else{
                    wListHH.sort((a,b)=>a.noiDung.compareTo(b.noiDung));
                  }
                  rIsSort.state = !wIsSort;
                }),
                DataColumn2(label: _title('Hoa hồng'),numeric: true,onSort: (i,t){
                  rColumnSort.state = i;
                  if(wIsSort){
                    wListHH.sort((a,b)=>b.hoaHong.compareTo(a.hoaHong));
                  }else{
                    wListHH.sort((a,b)=>a.hoaHong.compareTo(b.hoaHong));

                  }
                  rIsSort.state = !wIsSort;
                }),
              ],
              rows: _rows(wListHH, ref),
            ),
          ),
        ),
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

final filterHoaHongPVD = ChangeNotifierProvider.autoDispose<FilterHoaHong>((ref) {
  return FilterHoaHong();
});


class FilterHoaHong extends ChangeNotifier{
  String? phieuThuID;
  String? maHD;
  String? user;
  String? ngayThu;
  String? hoaHongThang;
  String? hoaHong;

  set setPhieuThu(String? val){
    phieuThuID = val;
    notifyListeners();
  }

  set setHoaHong(String? val){
    hoaHong = val;
    notifyListeners();
  }
  set setMaHD(String? val){
    maHD = val;
    notifyListeners();
  }

  set setUser(String? val){
    user = val;
    notifyListeners();
  }

  set setNgayThu(String? val){
    ngayThu = val;
    notifyListeners();
  }

  set setHHThang(String? val){
    hoaHongThang = val;
    notifyListeners();
  }



}
