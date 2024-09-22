import 'package:flutter/cupertino.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../../../data/data.dart';


class DsKhachTable extends ChangeNotifier{
  late PlutoGridStateManager stateManager;

  void addAllRow(List<Khach> khach){
    List<PlutoRow> rows = List.generate(khach.length, (i)=>PlutoRow(cells: {
      'num':PlutoCell(value: i+1),
      'MaKH': PlutoCell(value: khach[i].maKH),
      'TenGoi': PlutoCell(value: khach[i].tenGoi),
      'TenMoRong': PlutoCell(value: khach[i].tenMoRong),
      'DiaChi': PlutoCell(value: khach[i].diaChi),
      'NguonLienHe': PlutoCell(value: khach[i].nguonLienHe),
      'TenCty': PlutoCell(value: khach[i].tenCty),
      // 'MaSP': PlutoCell(value: khach[i].maSP),
      'KhuVuc':PlutoCell(value: khach[i].khuVuc),
      'DienThoai':PlutoCell(value: khach[i].dienThoai),
      'SoTien': PlutoCell(value: khach[i].soTien),
      'GhiChu': PlutoCell(value: khach[i].ghiChu),
    }));
    stateManager.removeAllRows();
    stateManager.appendRows(rows);
    stateManager.setShowLoading(false);
  }

  // void addRow(Khach khach){
  //   late int num;
  //   if(stateManager.rows.isEmpty) {
  //     num = 1;
  //   } else {
  //     num = stateManager.rows.last.cells['num']!.value + 1 ;
  //   }
  //   PlutoRow row = PlutoRow(cells: {
  //     'num':PlutoCell(value: num),
  //     'MaKH': PlutoCell(value: khach.maKH),
  //     'TenGoi': PlutoCell(value: khach.tenGoi),
  //     'TenMoRong': PlutoCell(value: khach.tenMoRong),
  //     'DiaChi': PlutoCell(value: khach.diaChi),
  //     'NguonLienHe': PlutoCell(value: khach.nguonLienHe),
  //     'TenCty': PlutoCell(value: khach.tenCty),
  //     'MaSP': PlutoCell(value: khach.maSP),
  //     'KhuVuc':PlutoCell(value: khach.khuVuc),
  //     'DienThoai':PlutoCell(value: khach.dienThoai),
  //     'SoTien': PlutoCell(value: khach.soTien),
  //     'GhiChu': PlutoCell(value: khach.ghiChu),
  //   });
  //   stateManager.appendRows([row]);
  // }
}