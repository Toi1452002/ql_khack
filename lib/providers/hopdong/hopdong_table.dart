import 'package:flutter/cupertino.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:ql_khach/utils/utils.dart';

import '../../../data/data.dart';


class HdTableNotifier extends ChangeNotifier{
  late PlutoGridStateManager stateManager;

  void addAllRow(List<Hopdong> hopDong){
    List<PlutoRow> rows = List.generate(hopDong.length, (i)=>PlutoRow(cells: {
      'num':PlutoCell(value: i+1),
      'MaHD':PlutoCell(value: hopDong[i].maHD),
      'MaSP':PlutoCell(value: hopDong[i].maSP),
      'MaSPCT':PlutoCell(value: hopDong[i].maSPCT),
      'TenGoi':PlutoCell(value: hopDong[i].tenGoi),
      'TenMoRong':PlutoCell(value: hopDong[i].tenMoRong),
      'TenCty':PlutoCell(value: hopDong[i].tenCty),
      'MaKichHoat':PlutoCell(value: hopDong[i].maKichHoat),
      'ThoiHan':PlutoCell(value: strThoiHan[hopDong[i].thoiHan]),
      'NgayHetHan':PlutoCell(value: hopDong[i].ngayHetHan),
      'Phi':PlutoCell(value: hopDong[i].phi),
      'ThucThu':PlutoCell(value: hopDong[i].thucThu),
      'NgayTruyCap': PlutoCell(value: hopDong[i].ngayTruyCap),
      'Con': PlutoCell(value: hopDong[i].soNgayConLai),
      'DaKichHoat': PlutoCell(value: hopDong[i].daKichHoat)

    }));
    stateManager.removeAllRows();
    stateManager.appendRows(rows);
    stateManager.setShowLoading(false);
  }
}