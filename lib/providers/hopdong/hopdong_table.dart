import 'package:flutter/cupertino.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:ql_khach/utils/utils.dart';

import '../../../data/data.dart';


class HdTableNotifier extends ChangeNotifier{
  late PlutoGridStateManager stateManager;

  // void addAllRow(List<Hopdong> hopDong){
  //   List<PlutoRow> rows = List.generate(hopDong.length, (i){
  //     final hd = hopDong[i];
  //     return PlutoRow(cells: {
  //       'num':PlutoCell(value: i+1),
  //       'MaHD':PlutoCell(value: hd.maHD),
  //       'MaSP':PlutoCell(value: hd.maSP),
  //       'MaSPCT':PlutoCell(value: hd.maSPCT),
  //       'TenGoi':PlutoCell(value: hd.tenGoi),
  //       'TenMoRong':PlutoCell(value: hd.tenMoRong),
  //       'TenCty':PlutoCell(value: hd.tenCty),
  //       'MaKichHoat':PlutoCell(value: hd.maKichHoat),
  //       'Seri':PlutoCell(value: hd.seri),
  //       'ThoiHan':PlutoCell(value: strThoiHan[hd.thoiHan]),
  //       'NgayHetHan':PlutoCell(value: hd.ngayHetHan),
  //       'Phi':PlutoCell(value: hd.phi),
  //       'ThucThu':PlutoCell(value: hd.thucThu),
  //       'NgayTruyCap': PlutoCell(value: hd.ngayTruyCap),
  //       'MoTa': PlutoCell(value: hd.moTa),
  //       'Con': PlutoCell(value: hd.soNgayConLai),
  //       'DaKichHoat': PlutoCell(value: hd.daKichHoat),
  //       'DN': PlutoCell(value: hd.doanhNghiep ? 1 : 0),
  //
  //     });
  //   });
  //   stateManager.removeAllRows();
  //   stateManager.appendRows(rows);
  //   stateManager.setShowLoading(false);
  // }


  void filter(List<Hopdong> hopDong, {String thang = '1', bool DN = false}){
    hopDong = hopDong.where((e){
      bool thoiHan = thang == '-1' ? true :  e.thoiHan == thang.toInt;
      bool dn = e.doanhNghiep == DN;
      return thoiHan && dn;
    }).toList();
    List<PlutoRow> rows = List.generate(hopDong.length, (i){
      final hd = hopDong[i];
      return PlutoRow(cells: {
        'num':PlutoCell(value: i+1),
        'MaHD':PlutoCell(value: hd.maHD),
        'MaSP':PlutoCell(value: hd.maSP),
        'MaSPCT':PlutoCell(value: hd.maSPCT),
        'TenGoi':PlutoCell(value: hd.tenGoi),
        'TenMoRong':PlutoCell(value: hd.tenMoRong),
        'TenCty':PlutoCell(value: hd.tenCty),
        'MaKichHoat':PlutoCell(value: hd.maKichHoat),
        'Seri':PlutoCell(value: hd.seri),
        'ThoiHan':PlutoCell(value: strThoiHan[hd.thoiHan]),
        'NgayHetHan':PlutoCell(value: hd.ngayHetHan),
        'Phi':PlutoCell(value: hd.phi),
        'ThucThu':PlutoCell(value: hd.thucThu),
        'NgayTruyCap': PlutoCell(value: hd.ngayTruyCap),
        'MoTa': PlutoCell(value: hd.moTa),
        'Con': PlutoCell(value: hd.soNgayConLai),
        'DaKichHoat': PlutoCell(value: hd.daKichHoat),
        'DN': PlutoCell(value: hd.doanhNghiep ? 1 : 0),

      });
    });
    stateManager.removeAllRows();
    stateManager.appendRows(rows);
    stateManager.setShowLoading(false);

  }
}