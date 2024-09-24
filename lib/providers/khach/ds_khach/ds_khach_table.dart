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

  // }
}